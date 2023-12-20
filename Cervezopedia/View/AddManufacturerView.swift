//
//  AddManufacturerView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct AddManufacturerView: View {
    @State private var addingLogo = false
    
    @State private var name = ""
    @State private var location = "\(Locale.current.region!.identifier)" // TODO: - Extraer lógica de regiones a un gestor de regiones
    @State private var logoName = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Añadir fabricante").font(.title2).foregroundColor(.accentColor)
            Form {
                Section(header: Text("Nombre")) { TextField("...", text: $name).textInputAutocapitalization(.never) }
                Section (header: Text("Región")) { RegionPicker(location: $location) }
                
                Section (header: Text("Vista previa")) {
                    ManufacturerRowView(name: name, location: location, logo: logoName)
                }
                
                Button("Añadir logo") {
                    addingLogo = true
                }.sheet(isPresented: $addingLogo) {
                    LogoPicker(selectedLogoName: $logoName)
                }
                
                Button(action: {
                    addManufacturer()
                }) {
                    Text("Añadir")
                }
            }
            .formStyle(.grouped)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            }
        }.padding(.top)
    }
    
    private func addManufacturer() {
        if let toAdd = ManufacturerModel(name: name, location: location, withLogoName: logoName) {
            if (ManufacturerManager.shared.add(toAdd: toAdd)) {
                Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                isPresented = false
            } else {
                alertMessage = "Ya existe un fabricante igual"
                showAlert = true
            }
        } else {
            alertMessage = "Parámetros erroneos al crear el fabricante"
            showAlert = true
        }
    }
}
