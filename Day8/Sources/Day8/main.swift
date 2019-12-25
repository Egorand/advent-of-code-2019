import Utils

struct Layer: CustomStringConvertible {
  let id: Int
  let pixels: [[Character]]
  
  var height: Int {
    return pixels.count
  }
  var width: Int {
    return pixels[0].count
  }
  
  var description: String {
    var result = "Layer \(id): "
    let indent = result.count
    for i in 0..<pixels.count {
      if i > 0 {
        result.append("\n")
        for _ in 0..<indent {
          result.append(" ")
        }
      }
      for j in 0..<pixels[i].count {
        result += String(pixels[i][j])
      }
    }
    return result
  }
  
  init(id: Int, pixels: [[Character]]) {
    self.id = id
    self.pixels = pixels
  }
}

func getPictureLayers(pixels: String, layerWidth: Int, layerHeight: Int) -> ([Layer], Int) {
  var layers = [Layer]()
  var pixelsPointer = 0
  var fewestZerosInLayer = Int.max
  var layerWithFewestZerosMarker = 0
  while pixelsPointer < pixels.count {
    var currentLayerPixels = [[Character]]()
    var currentLayerCharacterCounts = [Character:Int]()
    for _ in 0..<layerHeight {
      var currentRow = [Character]()
      for _ in 0..<layerWidth {
        let pixel = pixels[pixels.index(pixels.startIndex, offsetBy: pixelsPointer)]
        currentRow.append(pixel)
        currentLayerCharacterCounts[pixel, default: 0] += 1
        pixelsPointer += 1
      }
      currentLayerPixels.append(currentRow)
    }
    layers.append(Layer(id: layers.count + 1, pixels: currentLayerPixels))
    currentLayerPixels.removeAll()
    
    let zerosInLayer = currentLayerCharacterCounts["0"] ?? 0
    if zerosInLayer < fewestZerosInLayer {
      layerWithFewestZerosMarker = (currentLayerCharacterCounts["1"] ?? 0) * (currentLayerCharacterCounts["2"] ?? 0)
      fewestZerosInLayer = zerosInLayer
    }
  }
  return (layers, layerWithFewestZerosMarker)
}

func printMessageFromLayers(layers: [Layer]) {
  let messageWidth = layers[0].width
  let messageHeight = layers[0].height
  for i in 0..<messageHeight {
    for j in 0..<messageWidth {
      for layer in layers {
        let pixel = layer.pixels[i][j]
        if pixel == "0" {
          print(" ", terminator: "")
          break
        } else if pixel == "1" {
          print("█", terminator: "")
          break
        }
      }
      print(" ", terminator: "")
    }
    print("\n", terminator: "")
  }
}

var pixels = readLines(path: "\(currentDir(currentFile: #file))/test-space-image-format.txt")[0]
//for (layer, _) in getPictureLayers(pixels: pixels, layerWidth: 3, layerHeight: 2) {
//  print(layer)
//}

pixels = readLines(path: "\(currentDir(currentFile: #file))/input-space-image-format.txt")[0]
let (layers, result) = getPictureLayers(pixels: pixels, layerWidth: 25, layerHeight: 6)
for layer in layers {
  print(layer)
}
print(result)
printMessageFromLayers(layers: layers)
