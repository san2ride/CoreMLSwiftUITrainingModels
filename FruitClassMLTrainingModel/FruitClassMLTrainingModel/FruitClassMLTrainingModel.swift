//
//  FruitClassMLTrainingModel.swift
//  FruitClassMLTrainingModel
//
//  Created by don't touch me on 1/31/24.
//

import SwiftUI
import CoreML
import Vision

struct FruitClassMLTrainingModel: View {
    
    @State private var showSheet: Bool = false
    @State private var showPhotoOptions: Bool = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var classificationLabel: String = ""
    
    private let classifier = VisionClassifier(mlModel: FruitClassifier_1().model)
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()
                  Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Button("Choose Picture") {
                    // open action sheet
                    self.showSheet = true
                    
                }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                            .default(Text("Photo Library")) {
                                // open photo library
                                self.showPhotoOptions = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                // open camera
                                self.showPhotoOptions = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                }
                Text(classificationLabel)
                    .font(.largeTitle)
                    .padding(.top, 80)
                
                Spacer()
                Button("Classify") {
                    if let img = self.image {
                        // perform image classification
                        classifier?.classify(img) { result in
                            classificationLabel = result
                        }
                    }
                    
                }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(10)
                
            }
            .navigationBarTitle("Image Classification")
        }.sheet(isPresented: $showPhotoOptions) {
            ImagePicker(image: self.$image, isShown: self.$showPhotoOptions, sourceType: self.sourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FruitClassMLTrainingModel()
    }
}
