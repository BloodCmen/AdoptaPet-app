import Foundation
import FirebaseAuth

final class AuthService {

    private let auth = Auth.auth()
    private let usuarioService = UsuarioService()

    // MARK: - Registrar usuario

    func registrar(
        nombre: String,
        correo: String,
        contrasena: String
    ) async throws -> Usuario {

        // Crear cuenta en Firebase Authentication
        let resultado = try await auth.createUser(
            withEmail: correo,
            password: contrasena
        )

        let usuarioFirebase = resultado.user

        // Crear perfil en Firestore
        let nuevoUsuario = Usuario(
            uid: usuarioFirebase.uid,
            nombre: nombre,
            correo: correo,
            rol: "CLIENTE",
            proveedor: "EMAIL",
            fechaRegistro: Date()
        )

        try await usuarioService.crearUsuario(nuevoUsuario)

        return nuevoUsuario
    }

    // MARK: - Iniciar sesión

    func iniciarSesion(
        correo: String,
        contrasena: String
    ) async throws -> Usuario {

        // Autenticar con Firebase
        let resultado = try await auth.signIn(
            withEmail: correo,
            password: contrasena
        )

        let uid = resultado.user.uid

        // Recuperar perfil de Firestore
        guard let usuario = try await usuarioService.obtenerUsuario(uid: uid) else {
            throw NSError(
                domain: "AuthService",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No se encontró el perfil del usuario."
                ]
            )
        }

        return usuario
    }

    // MARK: - Obtener usuario actual

    func obtenerUsuarioActual() async throws -> Usuario? {

        guard let usuarioFirebase = auth.currentUser else {
            return nil
        }

        return try await usuarioService.obtenerUsuario(
            uid: usuarioFirebase.uid
        )
    }

    // MARK: - Verificar sesión

    func haySesionActiva() -> Bool {
        return auth.currentUser != nil
    }

    // MARK: - Cerrar sesión

    func cerrarSesion() throws {
        try auth.signOut()
    }
}
