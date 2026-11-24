
import SwiftUI

struct ContentView: View {

    // ViewModel compartido
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {

        Group {

            // Comprobando sesión
            if authViewModel.estaCargando {

                VStack(spacing: 15) {

                    ProgressView()
                        .tint(.orange)
                        .scaleEffect(1.4)

                    Text("Preparando AdoptaPet...")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }

            }

            // Usuario autenticado
            else if authViewModel.estaAutenticado {

                MainView(authViewModel: authViewModel)

            }

            // Sin sesión
            else {

                NavigationStack {
                    LoginView(authViewModel: authViewModel)
                }

            }
        }
        .animation(.easeInOut, value: authViewModel.estaCargando)
        .animation(.easeInOut, value: authViewModel.estaAutenticado)
    }
}

#Preview {
    ContentView()
}
