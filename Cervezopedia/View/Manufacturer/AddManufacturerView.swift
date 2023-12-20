//
//  AddManufacturerView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct AddManufacturerView: View {
    @Binding var isPresented: Bool
    
    @State private var addingLogo = false
    
    @State private var name = ""
    @State private var location = "\(Locale.current.region!.identifier)" // TODO: - Extraer lógica de regiones a un gestor de regiones
    @State private var logoName = ""
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Text("Añadir Fabricante")
            .font(.title)
            .padding()
        Form {
            Button {
                addingLogo = true
            } label: {
                Label("Añadir logo", systemImage: "plus")
            }
            .sheet(isPresented: $addingLogo) {
                LogoPicker(isPresented: $addingLogo, pickedLogoName: $logoName)
            }
            
            Section(header: Text("Nombre")) { TextField("...", text: $name).textInputAutocapitalization(.never) }
            
            Section (header: Text("Región")) { RegionPicker(location: $location) }
            
            Section (header: Text("Vista previa")) {
                if let manufacturer = ManufacturerModel(name: name, location: location, logoName: logoName) {
                    ManufacturerRowView(manufacturer: manufacturer)
                } else {
                    Text("No hay vista previa disponible")
                }
            }
            
            Button("Añadir") {
                addManufacturer()
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error al añadir fabricante"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
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
    
    private func addManufacturer() { // TODO: - sustituir "if"-s por "guard"-s
        if let toAdd = ManufacturerModel(name: name, location: location, logoName: logoName) {
            if (ManufacturerManager.shared.add(toAdd: toAdd)) {
                Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                isPresented = false
            } else {
                alertMessage = "Ya existe un fabricante igual"
                isShowingAlert = true
            }
        } else {
            alertMessage = "Parámetros erroneos al crear el fabricante"
            isShowingAlert = true
        }
    }
}
