import SwiftUI
import shared

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
	let phrases = Greeting().greet()

	var body: some View {
        ListView(phrases: viewModel.greetings)
            .onAppear{
                self.viewModel.startObserving()
            }
	}
}

extension ContentView{
    @MainActor
    class ViewModel: ObservableObject{
        @Published var greetings: Array<String> = []
        
        func startObserving(){
            Task{
                do{
                    let sequence = asyncSequence(for: Greeting().greet())
                    for try await phrase in sequence {
                        self.greetings.append(phrase)
                    }
                }catch{
                    print("Failed with error: \(error)")
                }
            }
        }
    }
}

struct ListView: View {
    let phrases: Array<String>
    var body: some View {
        List(phrases, id: \.self){
            Text($0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
