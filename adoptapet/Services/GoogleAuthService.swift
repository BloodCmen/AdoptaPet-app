
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import UIKit

final class GoogleAuthService {

    func iniciarSesion() async throws -> Usuario {

        guard let clienteID = FirebaseApp.app()?.options.clientID else {
            throw NSError(
                domain: "GoogleAuthService",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No se encontró el CLIENT_ID de Firebase."
                ]
            )
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clienteID
        )

        guard let ventana = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }),
              let controlador = ventana.rootViewController else {

            throw NSError(
                domain: "GoogleAuthService",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No se encontró la ventana de la aplicación."
                ]
            )
        }

        let resultado = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: controlador
        )

        guard let idToken = resultado.user.idToken?.tokenString else {
            throw NSError(
                domain: "GoogleAuthService",
                code: 3,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No se pudo obtener el token de Google."
                ]
            )
        }

        let accessToken = resultado.user.accessToken.tokenString

        let credencial = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )

        let resultadoFirebase = try await Auth.auth().signIn(
            with: credencial
        )

        let usuarioFirebase = resultadoFirebase.user

        let usuarioService = UsuarioService()

        if let usuarioExistente = try await usuarioService.obtenerUsuario(
            uid: usuarioFirebase.uid
        ) {
            return usuarioExistente
        }

        let nuevoUsuario = Usuario(
            uid: usuarioFirebase.uid,
            nombre: usuarioFirebase.displayName ?? "Usuario",
            correo: usuarioFirebase.email ?? "",
            rol: "CLIENTE",
            proveedor: "GOOGLE",
            fechaRegistro: Date()
        )

        try await usuarioService.crearUsuario(nuevoUsuario)

        return nuevoUsuario
    }
}
