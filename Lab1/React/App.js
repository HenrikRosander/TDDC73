import { StatusBar } from 'expo-status-bar';
import React from 'react';
import {Button,Image,StyleSheet, Text, View } from 'react-native';
import {TouchableOpacity, TextInput} from 'react-native-gesture-handler'


const UselessTextInput = () => {
  const [value, onChangeText] = React.useState('Useless Placeholder');}

export default function App() {
  
  return (
    <View style={styles.container}>

    <Image source={require('./img/Image.png')}  style={[{
    transform: [{ scaleX: .3}, {scaleY: .3}, {translateY: -100}]
    }]}/>
          <View  style={[{transform: [{translateY: -110}]
          }]}>
          <View style={[{
          transform: [{ translateX: 100}, {translateY: -91}]
          }]}>
          <TouchableOpacity
          style={styles.button1}>
          <Text style={{fontWeight : "bold"}}>  BUTTON </Text>
          </TouchableOpacity>
          </View>

          <View style={[{
          transform: [{ translateX: -100}, {translateY: -130}]
          }]}>

          <TouchableOpacity
          style={styles.button2}>
          <Text style={{fontWeight : "bold"}}>  BUTTON </Text>
          </TouchableOpacity>
          </View>
          
          <View style={[{
          transform: [{ translateX: 100}, {translateY: -62}]
          }]}>
          <TouchableOpacity
          style={styles.button3}>
          <Text style={{fontWeight : "bold"}}>  BUTTON </Text>
          </TouchableOpacity>
          </View>

          <View style={[{
          transform: [{ translateX: -100}, {translateY: -100}]
          }]}>
          <TouchableOpacity
          style={styles.button4}>
          <Text style={{fontWeight : "bold"}}>  BUTTON </Text>
          </TouchableOpacity>
          </View>
        <StatusBar/>
        </View>

      {/* Email and input field */}
      
        <View style={[styles.row, {transform:[{translateY: -130}]}]}>
        <Text style={[{transform : [{translateX : -40},{translateY : 10}] }]}>Email</Text>
          <TextInput
          placeholder="Enter your email" style={{ height: 40, borderColor: 'gray' , width: 250, borderBottomColor: "red", borderBottomWidth : 1, color:'red'}}
          /> 
          </View>

          {/* <View style={[styles.row, {
          transform: [{ translateY: 0}]
           }]}>
        <View style={styles.inputWrap}>
          <Text style={styles.Email} >Email</Text>
        </View>

        <View style={[styles.inputWrap, {transform: [{translateY : 0}], marginTop : 0}]}>
            <TextInput placeholder = "Enter Your Email" style={[styles.inputcvv, {transform: [{translateY : -100}, {translateX : -50}], paddingTop : -600}]} maxLength={25} />
        </View>
      </View> */}


    </View>
  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  }, 
  button1: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10,
    color: 'rgb(0,0,0)'
  },
  button2: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10,
   
    
  },
  button3: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10
  },
  button4: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10
  },
  row: {
    flex: 1,
    flexDirection: "row",
    marginVertical: 0
  },
  inputWrap: {
    flex: 1,
    borderColor: "#cccccc",
    borderBottomWidth: 1,
    
  },
  inputcvv: {
    zIndex : 1,
    fontSize: 14,
    color: "#6a4595",
    marginVertical: -0,
    marginHorizontal: 0,
    height: 40,
    width : 150
  }, 
  Email:{
    marginHorizontal:20,
    marginVertical: -26
  }
});