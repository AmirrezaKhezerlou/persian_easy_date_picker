import 'package:flutter/material.dart';
import 'package:persian_easy_date_picker/persian_easy_date_picker.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleWidget(),
    );
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  String date = 'Nothing selected yet!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()async{
              String? selectedDate = await PersianDatePicker.pick(
                context:  context,
              onError: (e){
                print('Void call back text : $e');
              },
              showStepper: true,
              borderRadius: 7,

                startYear: 1380,
                endYear: 1408,
              );
              setState(() {
                if(selectedDate != null){
               date = selectedDate;
                }
               
              });
            },
             child:const Text('Pick Shamsi Date'),
             ),
             const SizedBox(height: 30,),
             Text(date),
          ],
        ),
      ),
    );
  }
}