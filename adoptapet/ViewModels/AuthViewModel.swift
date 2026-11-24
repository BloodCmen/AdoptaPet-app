
import Foundation
import FirebaseAuth
import Foundation
import Combine
import FirebaseAuth


@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Servicios

    private let authService = AuthService()
    private let googleAuthService = GoogleAuthService()

    // MARK: - Estados

    @Published var usuario: Usuario?
    @Published var estaAutenticado = false
    @Published var estaCargando = true
    @Published var mensajeError: String?

    // MARK: - Observador de sesión

    private var listenerAuth: AuthStateDidChangeListenerHandle?

    init() {
        observarEstadoSesion()
    }

    // MARK: - Observar sesión de Firebase

    private func observarEstadoSesion() {

        listenerAuth = Auth.auth().addStateDidChangeListener {
            [weak self] _, usuarioFirebase in

            guard let self = self else { return }

            Task { @MainActor in

                if let usuarioFirebase = usuarioFirebase {

                    do {
                        let perfil = try await self.authService.obtenerUsuarioActual()

                        self.usuario = perfil
                        self.estaAutenticado = perfil != nil

                    } catch {
                        self.usuario = nil
                        self.estaAutenticado = false
                        self.mensajeError = error.localizedDescription
                    }

                    // Comprobamos que Firebase siga teniendo
                    // el mismo usuario autenticado.
                    if Auth.auth().currentUser?.uid == usuarioFirebase.uid {
                        self.estaCargando = false
                    }

                } else {

                    self.usuario = nil
                    self.estaAutenticado = false
                    self.estaCargando = false
                }
            }
        }
    }

    // MARK: - Registrar

    func registrar(
        nombre: String,
        correo: String,
        contrasena: String
    ) async {

        estaCargando = true
        mensajeError = nil

        do {
            let nuevoUsuario = try await authService.registrar(
                nombre: nombre,
                correo: correo,
                contrasena: contrasena
            )

            usuario = nuevoUsuario
            estaAutenticado = true

        } catch {
            mensajeError = error.localizedDescription
        }

        estaCargando = false
    }

    // MARK: - Iniciar sesión

    func iniciarSesion(
        correo: String,
        contrasena: String
    ) async {

        estaCargando = true
        mensajeError = nil

        do {
            let usuarioIngresado = try await authService.iniciarSesion(
                correo: correo,
                contrasena: contrasena
            )

            usuario = usuarioIngresado
            estaAutenticado = true

        } catch {
            mensajeError = error.localizedDescription
        }

        estaCargando = false
    }
    
    func iniciarSesionGoogle() async {

        estaCargando = true
        mensajeError = nil

        do {
            let usuarioGoogle = try await googleAuthService.iniciarSesion()

            usuario = usuarioGoogle
            estaAutenticado = true

        } catch {
            mensajeError = error.localizedDescription
        }

        estaCargando = false
    }

    // MARK: - Cerrar sesión

    func cerrarSesion() {

        do {
            try authService.cerrarSesion()

            usuario = nil
            estaAutenticado = false
            mensajeError = nil

        } catch {
            mensajeError = error.localizedDescription
        }
    }

    // MARK: - Limpiar error

    func limpiarError() {
        mensajeError = nil
    }

    // MARK: - Liberar listener

    deinit {
        if let listenerAuth = listenerAuth {
            Auth.auth().removeStateDidChangeListener(listenerAuth)
        }
    }
}
