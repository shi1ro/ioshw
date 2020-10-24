//
//  File.swift
//  171830568calculator
//
//  Created by apple on 2020/10/22.
//  Copyright © 2020 shi1ro. All rights reserved.
//

import Foundation
class CalculModel
{
    var pointFlag = false
    var buffer = "0"
    var numMode = false
    var radmode = false
    var secmode = false
    var lastope = "AC"
    var numlist:[Double] = []
    var opelist:[String] = []
    var buttondic:[String:Int] = [
        "mc" : -1,
        "m+" : -1,
        "m-" : -1,
        "mr" : -1,
        "AC" : 0,
        "="  : 0,
        "("  : 0,
        ")"  : 0,
        "0"  : 1,
        "1"  : 1,
        "2"  : 1,
        "3"  : 1,
        "4"  : 1,
        "5"  : 1,
        "6"  : 1,
        "7"  : 1,
        "8"  : 1,
        "9"  : 1,
        "."  : 1,
        "+"  : 2,
        "-"  : 2,
        "*"  : 2,
        "/"  : 2,
        "x^y" : 2,
        "y√x" : 2,
        "Rad" : 3,
        "2nd" : 3
    ]
    var operank:[String:Int] = [
        "(" : 0,
        "+" : 1,
        "-" : 1,
        "*" : 2,
        "/" : 2,
        "x^y" : 3,
        "y√x" : 3
    ]
    func ansNormalize(){
        var flg = true
        if let lastkind = buttondic[lastope]{
            if lastkind == 1{
                flg = false
            }
        }
        if flg{
            if let num = Double(buffer){
                if floor(num) == num{
                    let intnum = Int(num)
                    buffer = String(intnum)
                }
            }
        }
    }
    func parse (str: String)-> String{
        if let kind = buttondic[str]{
            if(kind == 0){
                parseBufClear(butstr: str)
            }
            else if(kind == 1){
                //is a number
                parseNum(numstr:str)
            }
            else if(kind == 2){
                parseBinaryOpe(bostr: str)
            }
            else if(kind == 3){
                parseModeChange(mostr: str)
            }
        }
        else{
            parseUnaryOpe(uostr: str)
        }
        lastope = str
        ansNormalize()
        return buffer
    }
    func reset(){
        pointFlag = false
        numMode = false
    }
    func angle2Rad(ang:Double)->Double{
        return ang / 180 * Double.pi
    }
    func rad2Ang(rad:Double)->Double{
        return rad / Double.pi * 180
    }
    func doubleabs(d1:Double,d2:Double)->Double{
        let ans = d1 - d2
        if ans < 0{
            return -ans
        }
        else{
            return ans
        }
    }
    func testTan(rad:Double)->Bool{
        var radnum = rad
        while radnum > Double.pi{
            radnum = radnum - Double.pi
        }
        while radnum < -Double.pi{
            radnum = radnum + Double.pi
        }
        if doubleabs(d1:radnum,d2:Double.pi/2) < 0.001 || doubleabs(d1:radnum,d2:-Double.pi/2) < 0.001{
            return false
        }
        else{
            return true
        }
    }
    func listCalOnce(){
        var errflg = false
        if !opelist.isEmpty{
            let opestr = opelist[opelist.endIndex - 1]
            if opestr == "("{
                
            }
            else{
                if numlist.count > 1{
                    let num1 = numlist[numlist.endIndex - 2]
                    let num2 = numlist[numlist.endIndex - 1]
                    var calnum = Double(0)
                    if opestr == "+"{
                        calnum = num1 + num2
                    }
                    else if opestr == "-"{
                        calnum = num1 - num2
                    }
                    else if opestr == "*"{
                        calnum = num1 * num2
                    }
                    else if opestr == "/"{
                        if num2 == 0{
                            calError()
                            errflg = true
                        }
                        else{
                            calnum = num1 / num2
                        }
                    }
                    else if opestr == "x^y"{
                        calnum = pow(num1,num2)
                    }
                    else if opestr == "y√x"{
                        if num2 == 0{
                            calError()
                            errflg = true
                        }
                        else{
                            calnum = pow(num1,1/num2)
                        }
                    }
                    if !errflg{
                        numlist.remove(at:numlist.endIndex-1)
                        numlist.remove(at:numlist.endIndex-1)
                        numlist.append(calnum)
                    }
                }
            }
            if !errflg{
                opelist.remove(at:opelist.endIndex - 1)
            }
        }
    }
    func calError(){
        buffer = "error"
        numlist.removeAll()
        opelist.removeAll()
        reset()
    }
    func addCurNumAndOpe(opestr:String){
        if let num = Double(buffer){
            if lastope != ")"{
                numlist.append(num)
            }
            if let curpri = operank[opestr]{
                while !opelist.isEmpty{
                    let stacktoppri = operank[opelist[opelist.endIndex - 1]]
                    if curpri <= stacktoppri!{
                        listCalOnce()
                        if buffer != "error"{
                            buffer = String(numlist[numlist.endIndex-1])
                        }
                    }
                    else{
                        break
                    }
                }
            }
            if buffer != "error"{
                opelist.append(opestr)
            }
        }
        else{
            calError()
        }
    }
    func parseBinaryOpe(bostr:String){
        var flg = false
        if let lastkind = buttondic[lastope]{
            if lastkind == 2{
                    flg = true
            }
        }
        if !flg {
            if buffer == "error"{
                calError()
           }
           else{
               addCurNumAndOpe(opestr: bostr)
           }
        }
        reset()
    }
    func parseModeChange(mostr:String){
        if(mostr == "Rad"){
            radmode = !radmode
        }
   /*     else if(mostr == "2nd"){
            secmode = !secmode
        }*/
    }
    func parseUnaryOpe(uostr:String){
        if  let num = Double(buffer) {
            if(uostr == "+/-"){
                if(buffer.hasPrefix("-")){
                    let substr = buffer.suffix(buffer.count - 1)
                    buffer = String(substr)
                }
                else if(num != 0){
                    buffer = "-" + buffer
                }
     //           print(buffer)
            }
            else if(uostr == "%"){
                let calnum = 0.01 * num
                buffer = String(calnum)
    //            print(buffer)
            }
            else if(uostr == "sin"){
                var trinum = num
                if !radmode {
                    trinum = angle2Rad(ang: num)
                }
                let calnum = sin(trinum)
                buffer = String(calnum)
   //           print(buffer)
                reset()
            }
            else if(uostr == "sin-1"){
                var calnum = Double(0)
                if(num < -1 || num > 1){
                    calError()
                }
                else{
                    calnum = asin(num)
                    if !radmode{
                        calnum = rad2Ang(rad: calnum)
                    }
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "cos"){
                var trinum = num
                if !radmode {
                    trinum = angle2Rad(ang: num)
                }
                let calnum = cos(trinum)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "cos-1"){
                var calnum = Double(0)
                if(num < -1 || num > 1){
                    calError()
                }
                else{
                    calnum = acos(num)
                    if !radmode{
                        calnum = rad2Ang(rad: calnum)
                    }
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "tan-1"){
                var calnum = Double(0)
                if(num == 1){
                    calError()
                }
                else{
                    calnum = atan(num)
                    if !radmode{
                        calnum = rad2Ang(rad: calnum)
                    }
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "tan"){
                var trinum = num
                if !radmode {
                    trinum = angle2Rad(ang: num)
                }
                if(!testTan(rad: trinum)){
                    calError()
                }
                else{
                    let calnum = tan(trinum)
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "sinh"){
                let calnum = sinh(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "sinh-1"){
                let calnum = asinh(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "cosh"){
                let calnum = cosh(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "cosh-1"){
                if num < 1{
                    calError()
                }
                else{
                    let calnum = acosh(num)
                    buffer = String(calnum)
                }
                reset()
            }
          else if(uostr == "tanh"){
                let calnum = tanh(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "tanh-1"){
                if num >= 1 || num <= -1{
                    calError()
                }
                else{
                    let calnum = atanh(num)
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "1/x"){
                if num == 0{
                    calError()
                }
                else{
                    let calnum = 1 / num
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "2√x"){
                if num < 0{
                    calError()
                }
                else{
                    let calnum = sqrt(num)
                    buffer = String(calnum)
                }
                reset()
            }
            else if(uostr == "3√x"){
                let calnum = cbrt(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "e^x"){
                let calnum = exp(num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "10^x"){
                let calnum = pow(10,num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "2^x"){
                let calnum = pow(2,num)
                buffer = String(calnum)
                reset()
            }
            else if(uostr == "ln"){
                if num <= 0{
                    calError()
                }
                else{
                    let calnum = log(num)
                    buffer = String(calnum)
                    reset()
                }
            }
            else if(uostr == "log10"){
                if num <= 0{
                    calError()
                }
                else{
                    let calnum = log10(num)
                    buffer = String(calnum)
                    reset()
                }
            }
            else if(uostr == "log2"){
                if num <= 0{
                    calError()
                }
                else{
                    let calnum = log2(num)
                    buffer = String(calnum)
                    reset()
                }
            }
            else if(uostr == "e"){
                buffer = String(M_E)
                reset()
            }
            else if(uostr == "π"){
                buffer = String(Double.pi)
                reset()
            }
            else if(uostr == "Rand"){
                buffer = String(Double.random(in: 0..<1))
                reset()
            }
            else if(uostr == "x!"){
                if num < 0{
                    calError()
                }
                else
                {
                    var intite = 1
                    var calnum = 1
                    while Double(intite) < num{
                        intite += 1
                        calnum *= intite
                    }
                    buffer = String(calnum)
                    reset()
                }
            }
        }
            
    }
    func parseBufClear(butstr:String){
        if butstr == "("{
            if let lastkind = buttondic[lastope]{
                if lastkind == 2{
                    opelist.append(butstr)
                }
            }
        }
        else if butstr == ")"{
            if let num = Double(buffer){
                numlist.append(num)
            }
            var calnum = Double(0)
            while (!opelist.isEmpty){
                if  opelist[opelist.endIndex-1] != "("{
                    listCalOnce()
                }
                else
                {
                    opelist.remove(at: opelist.endIndex-1)
                    break
                }
            }
            if !numlist.isEmpty{
                calnum = numlist[numlist.endIndex-1]
                buffer = String(calnum)
            }
            else{
                if buffer != "error"{
                    buffer = "0"
                }
            }
        }
        else if butstr == "AC"{
            numlist.removeAll()
            opelist.removeAll()
            buffer = String(0)
        }
        else if butstr == "="{
            if buffer == "error"{
                calError()
            }
            else{
                if lastope != ")"{
                    if let num = Double(buffer){
                        numlist.append(num)
                        }
                }
            }
            while !opelist.isEmpty{
                listCalOnce()
            }
            var calnum = Double(0)
            if !numlist.isEmpty{
                calnum = numlist[0]
                buffer = String(calnum)
            }
            else{
                if buffer != "error"{
                    buffer = "0"
                }
            }
            numlist.removeAll()
            opelist.removeAll()
        }
        reset()
    }
    func parseNum(numstr:String){
        if(!numMode){
            if(lastope == ")"){
                numlist.removeAll()
                opelist.removeAll()
            }
            if(numstr == ".")
            {
                buffer = "0."
                pointFlag = true
            }
            else
            {
                buffer = numstr
            }
        }
        else{
            if(numstr == "." && !pointFlag)
            {
                buffer = buffer + "."
                pointFlag = true
            }
            else if(numstr != ".")
            {
               buffer = buffer + numstr
            }
        }
        numMode = true
    }
}
