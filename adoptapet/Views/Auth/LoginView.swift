
import SwiftUI

struct LoginView: View {

    @ObservedObject var authViewModel: AuthViewModel

    @State private var correo = ""
    @State private var contrasena = ""

    private let naranja = Color(
        red: 1.0,
        green: 0.42,
        blue: 0.16
    )

    var body: some View {

        ZStack {

            Color(red: 0.98, green: 0.97, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Spacer()

                Image(systemName: "pawprint.circle.fill")
                    .font(.system(size: 85))
                    .foregroundColor(naranja)

                Text("AdoptaPet")
                    .font(.system(size: 34, weight: .bold))

                Text("Encuentra a tu nuevo mejor amigo")
                    .foregroundColor(.secondary)

                VStack(spacing: 15) {

                    TextField("Correo electrónico", text: $correo)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    SecureField("Contraseña", text: $contrasena)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                }

                HStack {
                    Spacer()

                    NavigationLink {
                        ForgotPasswordView()
                    } label: {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(naranja)
                    }
                }

                if let error = authViewModel.mensajeError {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task {
                        await authViewModel.iniciarSesion(
                            correo: correo.trimmingCharacters(in: .whitespacesAndNewlines),
                            contrasena: contrasena
                        )
                    }
                } label: {

                    HStack {
                        if authViewModel.estaCargando {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Iniciar sesión")
                        }
                    }
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(naranja)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(correo.isEmpty || contrasena.isEmpty || authViewModel.estaCargando)
                
                
                HStack {

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))

                    Text("O CONTINÚA CON")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .fixedSize()

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }

                .padding(.vertical, 5)

                Button {

                    Task {
                        await authViewModel.iniciarSesionGoogle()
                    }

                } label: {

                    HStack(spacing: 12) {

                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 22))

                        Text("Continuar con Google")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(authViewModel.estaCargando)


                HStack {

                    Text("¿No tienes una cuenta?")
                        .foregroundColor(.secondary)

                    NavigationLink {
                        RegisterView(authViewModel: authViewModel)
                    } label: {
                        Text("Regístrate")
                            .fontWeight(.bold)
                            .foregroundColor(naranja)
                    }
                }
                .font(.system(size: 14))

                Spacer()
            }
            .padding(25)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        LoginView(authViewModel: AuthViewModel())
    }
}
