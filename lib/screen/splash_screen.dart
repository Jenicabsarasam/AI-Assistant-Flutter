import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/helper/pref.dart';
import 'package:ai_assistant/screen/home_screen.dart';
import 'package:ai_assistant/screen/onboarding_screen.dart';
import 'package:ai_assistant/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //wait for some time on splash and then move to next screen 
    Future.delayed(const Duration(seconds: 2),(){
      //Navigator.of(context).pushReplacement(
        //MaterialPageRoute(builder: (_)=>Pref.showOnboarding ? const  OnboardingScreen(): const HomeScreen()));
      Get.off(()=>
        Pref.showOnboarding ? const  OnboardingScreen(): const HomeScreen());
    });
    
  }
  @override
  Widget build(BuildContext context) {
    //Initializing device size
    mq=MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            const Spacer(flex: 2,),
            Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(mq.width * 0.05),
                child: Image.asset("assets/images/logo.png",
                width: mq.width * 0.4,
                ),
              ),
            ),
            const Spacer(),
            const CustomLoading(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}