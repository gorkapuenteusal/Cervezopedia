//
//  AddBeerView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import SwiftUI

struct AddBeerView: View {
    @Binding var isPresented: Bool
    @ObservedObject var manufacturer: ManufacturerModel
    
    @State private var addingBeerImage = false
    
    @State private var name = ""
    @State private var type: BeerType = BeerType.bock
    @State private var alcoholContent = 0.0
    @State private var caloricIntake = 0
    @State private var beerImageName = ""
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Text("Añadir Cerveza")
            .font(.title)
            .padding()
        Form {
            Button {
                addingBeerImage = true
            } label: {
                Label("Añadir imagen de cerveza", systemImage: "plus")
            }
            .sheet(isPresented: $addingBeerImage) {
                BeerImagePicker(isPresented: $addingBeerImage, pickedBeerImageName: $beerImageName)
            }
            
            Section(header: Text("Nombre")) {
                TextField("...", text: $name).textInputAutocapitalization(.never)
            }
            
            Section(header: Text("Tipo")) {
                Picker(selection: $type) {
                    ForEach(BeerType.allCases.sorted(by: { type1, type2 in
                        type1.rawValue < type2.rawValue
                    }), id: \.self) { t in
                        if (t != .sinFiltro) {
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
            
            Section(header: Text("Vista previa")) {
                if BeerModel(name: name, type: type, alcoholContent: alcoholContent, caloricIntake: caloricIntake, beerImageName: beerImageName) != nil {
                    BeerRowView(name: name, type: type, beerImageName: beerImageName)
                } else {
                    Text("No hay vista previa disponible")
                }
            }
            
            Button("Añadir") {
                addBeer()
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error al añadir cerveza"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }
        .overlay(
            VStack {
                Spacer()
                Text("Desliza hacia abajo para cancelar")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        )
    }
    
    private func addBeer() {
        if let toAdd = BeerModel(name: name, type: type, alcoholContent: alcoholContent, caloricIntake: caloricIntake, beerImageName: beerImageName) {
            if (manufacturer.addBeer(toAdd: toAdd)) {
                Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                isPresented = false
            } else {
                alertMessage = "Ya existe una cerveza igual del mismo fabricante"
                isShowingAlert = true
            }
        } else {
            alertMessage = "Parámetros erroneos al crear la cerveza"
            isShowingAlert = true
        }
    }
}
