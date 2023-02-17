import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Modio",style: Theme.of(context).textTheme.titleLarge,),
            titleSpacing: 20,
            toolbarHeight: 90,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HexColor("040305").withOpacity(0.9),
                      HexColor("283CAF").withOpacity(0.5),
                    ],
                  )),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.contactFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: cubit.subjectController,
                        validator: (value){
                          if(value!.isEmpty) {
                            return "Subject Can\'t be Empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.text_fields),
                          prefixIconColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Subject Here ...',
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        minLines: 6,
                        maxLines: null,
                        controller: cubit.bodyController,
                        validator: (value){
                          if(value!.isEmpty) {
                            return "Body Can\'t be Empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.short_text_outlined),
                          prefixIconColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Body Here ...',
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: (){
                        if(cubit.contactFormKey.currentState!.validate()) {

                        }
                      }, child: Text("Send"),)
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}
