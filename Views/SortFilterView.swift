import SwiftUI

enum SortBy: String, CaseIterable {
    case country = "By country", name = "By resort name", none = "None"
}

enum FilterBy: String, CaseIterable {
    case none = "None", country = "By country", size = "By resort size", price = "By price"
}

enum FilterByPrice: String, CaseIterable {
    case all = "All", low = "$", medium = "$$", high = "$$$"
}

enum FilterBySize: String, CaseIterable {
    case all = "All", small = "Small", medium = "Medium", large = "Large"
}

enum FilterByCountry: String, CaseIterable {
    case all = "All", france = "France", italy = "Italy", canada = "Canada", usa = "USA", austria = "Austria"
}

struct SortFilterView: View {
    let resorts: [Resort]
    
    @Binding var detailIsShowing: Bool
    
    @Binding var filteredAndSorted: [Resort]
    @Binding var isFilteredAndSorted: Bool
    
    @State private var filter = FilterBy.none
    
    @Binding var filterByPrice: FilterByPrice
    @Binding var filterBySize: FilterBySize
    @Binding var filterByCountry: FilterByCountry
    
    @Binding var sort: SortBy
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Sort")) {
                    Picker(selection: $sort) {
                        ForEach(SortBy.allCases, id: \.self) { sortCase in
                            Text("\(sortCase.rawValue )")
                        }
                    } label: {
                        Text("Sort")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Price filter")) {
                    Picker(selection: $filterByPrice) {
                        ForEach(FilterByPrice.allCases, id: \.self) { filter in
                            Text("\(filter.rawValue )")
                        }
                    } label: {
                        Text("Select price level")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Size filter")) {
                    Picker(selection: $filterBySize) {
                        ForEach(FilterBySize.allCases, id: \.self) { filter in
                            Text("\(filter.rawValue )")
                        }
                    } label: {
                        Text("Select resort size")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Country filter")) {
                    Picker(selection: $filterByCountry) {
                        ForEach(FilterByCountry.allCases, id: \.self) { filter in
                            Text("\(filter.rawValue )")
                        }
                    } label: {
                        Text("Select country")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle(Text("Sort and filter"))
            .navigationBarItems(trailing:
                                Button(action: {
                filteredAndSorted = filterAndSort()
                detailIsShowing = false
            }) {
                Text("Done")
            })
        }
    }
    
    func filterAndSort() -> [Resort] {
        var tempResorts = resorts

        
        switch filterBySize {
        case .all:
            print("no size filter applied")
        case .small:
            tempResorts = tempResorts.filter { $0.size == 1 }
        case .medium:
            tempResorts = tempResorts.filter { $0.size == 2 }
        case .large:
            tempResorts = tempResorts.filter { $0.size == 3 }
        }
        
        switch filterByPrice {
        case .all:
            print("no price filter applied")
        case .low:
            tempResorts = tempResorts.filter { $0.price == 1 }
        case .medium:
            tempResorts = tempResorts.filter { $0.price == 2 }
        case .high:
            tempResorts = tempResorts.filter { $0.price == 3 }
        }
        
        switch filterByCountry {
        case .all:
            print("no country filter applied")
        case .france:
            tempResorts = tempResorts.filter { $0.country == FilterByCountry.france.rawValue }
        case .italy:
            tempResorts = tempResorts.filter { $0.country == FilterByCountry.italy.rawValue }
        case .canada:
            tempResorts = tempResorts.filter { $0.country == FilterByCountry.canada.rawValue }
        case .usa:
            tempResorts = tempResorts.filter { $0.country == "United States" }
        case .austria:
            tempResorts = tempResorts.filter { $0.country == FilterByCountry.austria.rawValue }
        }
        
        
        switch sort {
        case .country:
            tempResorts.sort { $0.country < $1.country }
        case .name:
            tempResorts.sort { $0.name < $1.name }
        case .none:
            print("no sorting selected")
        }
        
        return tempResorts
    }
    
}
