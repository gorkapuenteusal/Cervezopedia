//
//  BeerDetailedView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import SwiftUI

struct BeerDetailedView: View {
    @StateObject var beer: BeerModel
    
    @State var name: String
    @State var type: BeerType
    @State var alcoholContent: Double
    @State var caloricIntake: Int
    @State var beerImageName: String
    
    @Binding var update: Bool
    
    @State private var isShowingAlert = false
    @State var isEditingBeerImage = false
    
    var body: some View {
        Text("Editando \"\(beer.name)\"")
        Form {
            Section(header: Text("Imagen de cerveza")) {
                Button {
                    isEditingBeerImage = true
                } label: {
                    Label("Editar imagen de cerveza", systemImage: "pencil")
                }
                .sheet(isPresented: $isEditingBeerImage) {
                    BeerImagePicker(isPresented: $isEditingBeerImage, pickedBeerImageName: $beerImageName)
                }
                Image(uiImage: BeerImageManager.shared.getBeerImage(withName: beerImageName))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            Section(header: Text("Nombre")) {
                TextField("...", text: $name).textInputAutocapitalization(.never)
            }
            
            Section(header: Text("Tipo")) {
                Picker(selection: $type) {
                    ForEach(BeerType.allCases.sorted(by: { type1, type2 in
                        type1.rawValue < type2.rawValue
                    }), id: \.self) { t in
                        if t != .sinFiltro {
                            Text(t.formattedString)
                        }
                    }
                } label: {
                    Text("Tipo de cerveza")
                }
            }
            
            Section(header: Text("Alcohol")) {
                HStack {
                    Slider(value: $alcoholContent, in: 0...20, step: 0.1)
                    Spacer()
                    Text("\(String(format: "%.1f", alcoholContent))º")
                }
            }
            
            Section() {
                HStack {
                    Stepper("Aporte calórico", value: $caloricIntake, in: 0...1000, step: 10)
                    Spacer()
                    Text("\(caloricIntake) kcal/100ml")
                }
            }
        }
        
        Button("Confirmar cambios") {
            if BeerModel(name: name, type: type, alcoholContent: alcoholContent, caloricIntake: caloricIntake, beerImageName: beerImageName) != nil {
                beer.name = name
                beer.type = type
                beer.alcoholContent = alcoholContent
                beer.caloricIntake = caloricIntake
                beer.beerImageName = beerImageName
                update.toggle()
                Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
            } else {
                isShowingAlert = true
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error al editar cerveza"), message: Text("Alguno de los parámetros es erróneo"), dismissButton: .default(Text("Ok")))
        }
    }
}
