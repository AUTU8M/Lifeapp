import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

class FaqAccessibilityWidget extends StatelessWidget {
  const FaqAccessibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringHelper.accessibility,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

   // accessLife app from multiple Devices
        Padding(
          padding: EdgeInsets.only(left: 18,top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "a.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.accessAppFromMultipleDevices,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only( left: 30,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-",  style: TextStyle(
                color: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w800,

              ),),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.accessAppFromMultipleDevicesDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24,),

        // access multiple profile on same device
        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "b.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.accessMultipleProfileOnSameDevice,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only( left: 30,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-",  style: TextStyle(
                color: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w800,

              ),),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.accessMultipleProfileOnSameDeviceDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24,),

        // is app available for android and ios

        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "c.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.isAppAvailableForAndroidAndIOS,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only( left: 30,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-",  style: TextStyle(
                color: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w800,

              ),),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.isAppAvailableForAndroidAndIOSDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24,),

        // why are some Levels Lock

        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "d.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.whyAreSomeLevelLock,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only( left: 30,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-",  style: TextStyle(
                color: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w800,

              ),),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.whyAreSomeLevelLockDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24,),



      ],
    );
  }
}
