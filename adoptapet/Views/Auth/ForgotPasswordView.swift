import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
@State private var correo = ""
    @State private var mensaje = ""
    @State private var mostrandoError = false
    @State private var enviando = false
    @State private var correoEnviado = false

    private let naranja = Color(
        red: 1.0,
        green: 0.42,
        blue: 0.16
    )

    var body: some View {

        ZStack {

            Color(
                red: 0.98,
                green: 0.97,
                blue: 0.95
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {

                // MARK: - Icono

                Image(systemName: "lock.rotation")
                    .font(.system(size: 42))
                    .foregroundColor(.white)
                    .frame(width: 85, height: 85)
                    .background(naranja)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 26)
                    )

                // MARK: - Información

                VStack(spacing: 10) {

                    Text("¿Olvidaste tu contraseña?")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                // MARK: - Correo

                VStack(alignment: .leading, spacing: 9) {

                    Text("Correo electrónico")
                        .font(.system(size: 14, weight: .semibold))

                    HStack(spacing: 12) {

                        Image(systemName: "envelope")
                            .foregroundColor(naranja)

                        TextField(
                            "Ingresa tu correo",
                            text: $correo
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
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

                // MARK: - Mensaje

                if !mensaje.isEmpty {

                    Text(mensaje)
                        .font(.system(size: 14))
                        .foregroundColor(
                            correoEnviado ? .green : .red
                        )
                        .multilineTextAlignment(.center)
                }

                // MARK: - Botón enviar

                Button {

                    Task {
                        await enviarCorreo()
                    }

                } label: {

                    HStack {

                        if enviando {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Enviar enlace")
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
                    correo.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty || enviando
                )
                .opacity(correo.isEmpty ? 0.6 : 1)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 65)
            .padding(.bottom, 30)
            .frame(maxWidth: 480)
        }
    }

    // MARK: - Enviar correo de recuperación

    private func enviarCorreo() async {

        enviando = true
        mensaje = ""
        correoEnviado = false

        do {

            try await Auth.auth().sendPasswordReset(
                withEmail: correo.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            )

            correoEnviado = true
            mensaje = "Si existe una cuenta asociada, recibirás instrucciones para recuperar tu contraseña."

        } catch {

            mensaje = "No se pudo procesar la solicitud. Verifica el correo e inténtalo nuevamente."
        }

        enviando = false
    }
}
