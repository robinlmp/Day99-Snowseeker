import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct ContentView: View {
    let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var resortsFilteredAndSorted: [Resort] = Bundle.main.decode("resorts.json")
    @State private var isFilteredAndSorted = false
    
    @ObservedObject var favourites = Favourites()
    
    @State private var filterSortShowing = false
    @State private var filterByPrice = FilterByPrice.all
    @State private var filterBySize = FilterBySize.all
    @State private var filterByCountry = FilterByCountry.all
    
    @State private var sort = SortBy.none
    
    
    var body: some View {
        NavigationView {
            List(resortsFilteredAndSorted) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .frame(minWidth: 170, alignment: .leading)
                    .layoutPriority(1)
                    
                    if favourites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favourite resort"))
                            .foregroundColor(.red)
                    }
                }
                .frame(height: 40)
                
            }
            
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing:
//                                    Menu {
                Button(action: {
                filterSortShowing = true
                }) {
                    Label("Sort and filter", systemImage: "slider.horizontal.3")
                })
            .sheet(isPresented: $filterSortShowing) {
                SortFilterView(resorts: allResorts, detailIsShowing: $filterSortShowing, filteredAndSorted: $resortsFilteredAndSorted, isFilteredAndSorted: $isFilteredAndSorted, filterByPrice: $filterByPrice, filterBySize: $filterBySize, filterByCountry: $filterByCountry, sort: $sort)
            }
            
            WelcomeView()
        }
        .environmentObject(favourites)
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}



extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
