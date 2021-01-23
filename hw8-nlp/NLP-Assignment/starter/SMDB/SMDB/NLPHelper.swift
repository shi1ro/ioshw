/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import NaturalLanguage
import Vision
var esCharToInt = [Character:Int]()
var intToEnChar = [Int:Character]()
func getLanguage(text: String) -> NLLanguage? {
  //To be replaced
    
    return NLLanguageRecognizer.dominantLanguage(for: text)
}

func getPeopleNames(text: String, block: (String) -> Void) {
  //To be replaced
    // 1
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = text
    // 2
    let options: NLTagger.Options = [
    .omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    // 3
    tagger.enumerateTags(
    in: text.startIndex..<text.endIndex, unit: .word,
    scheme: .nameType, options: options) { tag, tokenRange in
    // 4
    if tag == .personalName {
    block(String(text[tokenRange]))
    }
    return true

}
}

func getSearchTerms(text: String, language: String? = nil, block: (String) -> Void) {
  // To be replaced
    let tagger = NLTagger(tagSchemes: [.lemma])
    tagger.string = text
    if let language = language {
    tagger.setLanguage(NLLanguage(rawValue: language),
    range: text.startIndex..<text.endIndex)
    }
    let options: NLTagger.Options = [
    .omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    tagger.enumerateTags(
    in: text.startIndex..<text.endIndex, unit: .word,
    scheme: .lemma, options: options) { tag, tokenRange in
    let token = String(text[tokenRange]).lowercased()
    if let tag = tag {
    // 3
    let lemma = tag.rawValue.lowercased()
        block(lemma)
        if lemma != token{
            block(token)
        }
    }
    else{
        block(token)
    }
    return true
    }
}

func analyzeSentiment(text:String) -> Double? {
  // To be replaced
    // 2
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    tagger.string = text
    // 3
    let (tag, _) = tagger.tag(at: text.startIndex,
    unit: .paragraph,
    scheme: .sentimentScore)
    // 4
    guard let sentiment = tag,
    let score = Double(sentiment.rawValue)
    else { return nil }
    return score
}

func getSentimentClassifier() -> NLModel? {
  // To be replaced
  return try!NLModel(mlModel: SentimentClassifier().model)
}

func predictSentiment(text: String, sentimentClassifier: NLModel) -> String? {
  // To be replace
  return sentimentClassifier.predictedLabel(for: text)
}

// ------------------------------------------------------------------
// -------  Everything below here is for translation chapters -------
// ------------------------------------------------------------------

func getSentences(text: String) -> [String] {
  // To be replaced
    let splitchars:[Character] = [",",".","!","?"]
    var sens = [String]()
    var tempsen = ""
    for char in text{
        tempsen += String(char)
        if splitchars.contains(char){
            sens.append(tempsen)
            tempsen = ""
        }
    }
    print(sens)
    return sens
}
func getEncoderInput(text: String) -> MLMultiArray?{
    if esCharToInt.count == 0{
        let file = Bundle.main.url(forResource: "esCharToInt", withExtension: "json")!
        let data = try! Data(contentsOf: file)
        let esstrToInt = try! JSONDecoder().decode(Dictionary<String, Int>.self, from: data)
    
        for (key,value) in esstrToInt{
            let position = key.index(key.startIndex, offsetBy: 0)
            let firstChar = key[position]
            esCharToInt[firstChar] = value
        }
    }
    let cleanedText = text
    .filter { esCharToInt.keys.contains($0) }
    if cleanedText.isEmpty {
    return nil
    }
    // 2
    let vocabSize = esCharToInt.count
    let encoderIn = initMultiArray(
    shape: [NSNumber(value: cleanedText.count),
    1,
    NSNumber(value: vocabSize)])
    // 3
    for (i, c) in cleanedText.enumerated() {
    encoderIn[i * vocabSize + esCharToInt[c]!] = 1
    }
    return encoderIn
}
func getDecoderInput(encoderInput:MLMultiArray)->Es2EnCharDecoder16BitInput{
    if intToEnChar.count == 0{
        let file = Bundle.main.url(forResource: "intToEnChar", withExtension: "json")!
        let data = try! Data(contentsOf: file)
        let dict = try! JSONDecoder().decode(Dictionary<String, String>.self, from: data)
   
        for (key,value) in dict{
            let position = value.index(value.startIndex, offsetBy: 0)
            let firstChar = value[position]
            let int = Int(key)!
            intToEnChar[int] = firstChar
        }
    }
    // 1
    let encoder = Es2EnCharEncoder16Bit()
    let encoderOut = try! encoder.prediction(
    encodedSeq: encoderInput,
    encoder_lstm_h_in: nil,
    encoder_lstm_c_in: nil)
    // 2
    let decoderIn = initMultiArray(
    shape: [NSNumber(value: intToEnChar.count)])
    // 3
    return Es2EnCharDecoder16BitInput(
    encodedChar: decoderIn,
    decoder_lstm_h_in: encoderOut.encoder_lstm_h_out,
    decoder_lstm_c_in: encoderOut.encoder_lstm_c_out)


}
func spanishToEnglish(text: String) -> String? {
    // 1
    guard let encoderIn = getEncoderInput(text:text) else {
    return nil
    }
    // 2
    let decoderIn = getDecoderInput(encoderInput: encoderIn)
    // 3
    let decoder = Es2EnCharDecoder16Bit()
    let maxOutSequenceLength = 5000
    let startTokenIndex = 0
    let stopTokenIndex = 1
    var translatedText: [Character] = []
    var doneDecoding = false
    var decodedIndex = startTokenIndex
    while !doneDecoding {
    // 1
    decoderIn.encodedChar[decodedIndex] = 1
    // 2
    let decoderOut = try! decoder.prediction(input: decoderIn)
    // 3
    decoderIn.decoder_lstm_h_in = decoderOut.decoder_lstm_h_out
    decoderIn.decoder_lstm_c_in = decoderOut.decoder_lstm_c_out
    // 4
    decoderIn.encodedChar[decodedIndex] = 0
    // 1
    decodedIndex = argmax(array: decoderOut.nextCharProbs)
    // 2
    if decodedIndex == stopTokenIndex {
    doneDecoding = true
    } else {
    translatedText.append(intToEnChar[decodedIndex]!)
    }
    // 3
    if translatedText.count >= maxOutSequenceLength {
    doneDecoding = true
    }

    }
    return String(translatedText)
}
