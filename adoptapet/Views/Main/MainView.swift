import SwiftUI

struct MainView: View {

    @ObservedObject var authViewModel: AuthViewModel

    private let naranja = Color(
        red: 1.0,
        green: 0.42,
        blue: 0.16
    )

    var body: some View {

        ZStack {

            Color(red: 0.98, green: 0.97, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                HStack {

                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 30))
                        .foregroundColor(naranja)

                    Text("AdoptaPet")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Text(authViewModel.usuario?.rol ?? "CLIENTE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(naranja)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(naranja.opacity(0.12))
                        .clipShape(Capsule())
                }

                Spacer()

                Image(systemName: "pawprint.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(naranja)

                Text("¡Hola, \(authViewModel.usuario?.nombre ?? "usuario")!")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("Bienvenido a AdoptaPet")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)

                Text("Encuentra a tu próximo compañero y dale un hogar lleno de amor.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 25)

                Spacer()

                Button {
                    authViewModel.cerrarSesion()
                } label: {

                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Cerrar sesión")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(naranja)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }

            }
            .padding(25)
        }
    }
}
