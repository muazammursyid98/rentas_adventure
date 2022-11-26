import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../model/list_order.dart';

class ReceiptDisplay extends StatelessWidget {
  final ListOrder listOrder;
  const ReceiptDisplay({Key? key, required this.listOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String customerName = listOrder.name!;
    String customerPhoneNumber = listOrder.phoneNumber!;
    String customerTotalPrice = listOrder.totalPrice!;
    String invoiceNumber = listOrder.invoiceNumber!;
    String emailCustomer = listOrder.emailCustomer!;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 5.0,
      ),
      content: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.28,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "ORDER INFORMATION",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 8.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order ID",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      invoiceNumber,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Phone"),
                        SizedBox(height: 8),
                        Text("Name"),
                        SizedBox(height: 8),
                        Text("Order Time"),
                        SizedBox(height: 8),
                        Text("Merchant Number"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("+6$customerPhoneNumber"),
                        const SizedBox(height: 8),
                        Text(customerName),
                        const SizedBox(height: 8),
                        Text(listOrder.orderTime!),
                        const SizedBox(height: 8),
                        const Text("+6011-11414674")
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "ORDER SUMMARY",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 60,
                        child: Text("Num"),
                      ),
                      Text("Item"),
                      Spacer(),
                      SizedBox(
                        width: 70,
                        child: Text("Person"),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text("Price"),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...listOrder.listOrder!
                        .asMap()
                        .map((index, element) {
                          index++;
                          return MapEntry(
                              index,
                              Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Text(index.toString()),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                          child: Text(
                                              "${element.activityName!}\n( ${element.shiftName} )"),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: 70,
                                          child: Text(element.totalBookedSlot!),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                              "RM ${double.parse(element.totalPrice!).toStringAsFixed(2)}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  const Divider(),
                                ],
                              ));
                        })
                        .values
                        .toList()
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 8,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          // fixedSize: Size(250, 50),
                        ),
                        child: const Text(
                          "OK",
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 16,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          // fixedSize: Size(250, 50),
                        ),
                        child: const Text(
                          "Receipt",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
