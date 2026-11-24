
import SwiftUI

struct RegisterView: View {

    // MARK: - ViewModel

    @ObservedObject var authViewModel: AuthViewModel

    // MARK: - Estados

    @State private var nombre = ""
    @State private var correo = ""
    @State private var contrasena = ""
    @State private var confirmarContrasena = ""

    // MARK: - Colores

    private let naranja = Color(
        red: 1.0,
        green: 0.42,
        blue: 0.16
    )

    // MARK: - Validaciones

    private var formularioValido: Bool {

        !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        correo.contains("@") &&
        contrasena.count >= 6 &&
        contrasena == confirmarContrasena
    }

    var body: some View {

        ZStack {

            Color(
                red: 0.98,
                green: 0.97,
                blue: 0.95
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 25) {

                    // MARK: - Encabezado

                    VStack(spacing: 12) {

                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 42))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(naranja)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 25)
                            )

                        Text("Crear cuenta")
                            .font(.system(size: 29, weight: .bold))
                            .foregroundColor(.black)

                        Text("Únete a nuestra comunidad de adopción")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 30)

                    // MARK: - Formulario

                    VStack(spacing: 17) {

                        campo(
                            titulo: "Nombre completo",
                            placeholder: "Ingresa tu nombre",
                            icono: "person",
                            texto: $nombre
                        )

                        campo(
                            titulo: "Correo electrónico",
                            placeholder: "Ingresa tu correo",
                            icono: "envelope",
                            texto: $correo,
                            esCorreo: true
                        )

                        VStack(alignment: .leading, spacing: 9) {

                            Text("Contraseña")
                                .font(.system(size: 14, weight: .semibold))

                            HStack(spacing: 12) {

                                Image(systemName: "lock")
                                    .foregroundColor(naranja)

                                SecureField(
                                    "Crea una contraseña",
                                    text: $contrasena
                                )
                            }
                            .padding()
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        Color.gray.opacity(0.2),
                                        lineWidth: 1
                                    )
                            }
                        }

                        VStack(alignment: .leading, spacing: 9) {

                            Text("Confirmar contraseña")
                                .font(.system(size: 14, weight: .semibold))

                            HStack(spacing: 12) {

                                Image(systemName: "lock.fill")
                                    .foregroundColor(naranja)

                                SecureField(
                                    "Repite tu contraseña",
                                    text: $confirmarContrasena
                                )
                            }
                            .padding()
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        Color.gray.opacity(0.2),
                                        lineWidth: 1
                                    )
                            }
                        }
                    }

                    // MARK: - Validación

                    if !confirmarContrasena.isEmpty &&
                        contrasena != confirmarContrasena {

                        Text("Las contraseñas no coinciden.")
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let error = authViewModel.mensajeError {

                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // MARK: - Crear cuenta

                    Button {

                        Task {
                            await authViewModel.registrar(
                                nombre: nombre.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                correo: correo.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                contrasena: contrasena
                            )
                        }

                    } label: {

                        HStack {

                            if authViewModel.estaCargando {
                                ProgressView()
                                    .tint(.white)
                            } else {

                                Text("Crear cuenta")
                                    .font(.system(size: 16, weight: .bold))

                                Spacer()

                                Image(systemName: "arrow.right")
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(naranja)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                    }
                    .disabled(
                        !formularioValido ||
                        authViewModel.estaCargando
                    )
                    .opacity(formularioValido ? 1 : 0.6)

                    Text("Al registrarte, tu cuenta tendrá el rol de CLIENTE.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 35)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Componente de campo

    private func campo(
        titulo: String,
        placeholder: String,
        icono: String,
        texto: Binding<String>,
        esCorreo: Bool = false
    ) -> some View {

        VStack(alignment: .leading, spacing: 9) {

            Text(titulo)
                .font(.system(size: 14, weight: .semibold))

            HStack(spacing: 12) {

                Image(systemName: icono)
                    .foregroundColor(naranja)

                TextField(placeholder, text: texto)
                    .keyboardType(
                        esCorreo ? .emailAddress : .default
                    )
                    .textInputAutocapitalization(
                        esCorreo ? .never : .words
                    )
                    .autocorrectionDisabled(esCorreo)
            }
            .padding()
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        Color.gray.opacity(0.2),
                        lineWidth: 1
                    )
            }
        }
    }
}
