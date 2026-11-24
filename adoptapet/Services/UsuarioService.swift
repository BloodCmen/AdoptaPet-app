import Foundation
import FirebaseFirestore


final class UsuarioService {

    private let db = Firestore.firestore()
    private let coleccion = "usuarios"

    // MARK: - Crear usuario

    func crearUsuario(_ usuario: Usuario) async throws {

        let datos: [String: Any] = [
            "uid": usuario.uid,
            "nombre": usuario.nombre,
            "correo": usuario.correo,
            "rol": usuario.rol,
            "proveedor": usuario.proveedor,
            "fechaRegistro": Timestamp(date: usuario.fechaRegistro)
        ]

        try await db.collection(coleccion)
            .document(usuario.uid)
            .setData(datos)
    }

    // MARK: - Obtener usuario

    func obtenerUsuario(uid: String) async throws -> Usuario? {

        let documento = try await db.collection(coleccion)
            .document(uid)
            .getDocument()

        guard let datos = documento.data(),
              let nombre = datos["nombre"] as? String,
              let correo = datos["correo"] as? String,
              let rol = datos["rol"] as? String,
              let proveedor = datos["proveedor"] as? String
        else {
            return nil
        }

        let fechaRegistro = (datos["fechaRegistro"] as? Timestamp)?.dateValue() ?? Date()

        return Usuario(
            uid: uid,
            nombre: nombre,
            correo: correo,
            rol: rol,
            proveedor: proveedor,
            fechaRegistro: fechaRegistro
        )
    }
}
