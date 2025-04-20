
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/model/message.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
 final Message message;

 const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const r=Radius.circular(15);
    return message.msgType==MessageType.bot
    //bot
    ?Row(
      children: [
        const SizedBox(width: 6),
        CircleAvatar(
          radius: 19,
          backgroundColor: Colors.white,
          child: Image.asset('assets/images/logo.png',width: 26),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: mq.width*.6),
          margin: EdgeInsets.only(bottom: mq.height * 0.02,left: mq.width *  0.02),
          padding: EdgeInsets.symmetric(
            vertical: mq.height*.01, horizontal: mq.width * 0.02
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(133, 128, 83, 233)),
            borderRadius: const BorderRadius.only(topLeft: r,topRight: r,bottomRight: r)
          ),
          child: Text(message.msg,textAlign: TextAlign.center),
        )
      ],
    )
    : //user
    Row(mainAxisAlignment: MainAxisAlignment.end,
      children: [
  
        Container(
          constraints: BoxConstraints(maxWidth: mq.width*.6),
          margin: EdgeInsets.only(bottom: mq.height * 0.02,right: mq.width *  0.02),
          padding: EdgeInsets.symmetric(
            vertical: mq.height*.01, horizontal: mq.width * 0.02
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(133, 128, 83, 233)),
            borderRadius: const BorderRadius.only(topLeft: r,topRight: r,bottomLeft: r)
          ),
          child: message.msg.isEmpty ? 
          AnimatedTextKit(
            animatedTexts:[
              TypewriterAnimatedText(
                'Please wait...',
              speed: const Duration(milliseconds: 100),
              ),              
            ], repeatForever: true)
            : Text(
                message.msg,
                textAlign: TextAlign.center,
          ),
        ),
        const CircleAvatar(
          radius: 19,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_pin_rounded ,size: 26,color: Color.fromARGB(255, 32, 131, 212)),
          ),
        const SizedBox(width: 6),
      ]
    );
  }
}