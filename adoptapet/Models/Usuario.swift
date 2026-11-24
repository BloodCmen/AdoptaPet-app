
import Foundation

struct Usuario: Identifiable, Codable {

    var uid: String
    var nombre: String
    var correo: String
    var rol: String
    var proveedor: String
    var fechaRegistro: Date

    var id: String {
        uid
    }
}

