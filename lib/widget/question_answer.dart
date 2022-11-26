import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuestionAnswer extends StatelessWidget {
  const QuestionAnswer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return const DialogFAQ();
            });
      },
      child: Icon(
        FontAwesomeIcons.question,
        size: 6.h,
        color: Colors.white,
      ),
    );
  }
}

class DialogFAQ extends StatelessWidget {
  const DialogFAQ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 10.0,
      ),
      title: const Text(
        "FAQ",
        style: const TextStyle(fontSize: 24.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: HtmlWidget(
                // the first parameter (`html`) is required
                '''
              <p><strong>Common Q&amp;A </strong></p>

              <p><u><strong>1. White Water Rafting</strong></u></p>

              <p><strong>What do I need to bring/wear? </strong></p>

              <ul>
                <li>&bull; Quick-dry clothing.</li>
                <li>&bull; Strapped sandals/scuba booties/watersports shoes</li>
                <li>&bull; Straps for eyeglasses/spectacles.</li>
                <li>&bull; Sunblock lotion</li>
                <li>&bull; Set of dry clothes, towel, toiletries, personal medication, and pocket money.</li>
              </ul>

              <p>&nbsp;</p>

              <p><strong>Is there is a place to shower after rafting? </strong></p>

              <p>Yes, there are simple communal toilets and cold-water showers available at ADREN X BASE.</p>

              <p><strong>Can I bring my phone or camera? </strong></p>

              <p>Suggested to only bring <strong>waterproof </strong>devices with safety lanyards at your own risk.</p>

              <p><strong>I Have Asthma, Can I Join? </strong></p>

              <p>Yes you can, bring along your inhaler and notify the Guide Master</p>

              <p>&nbsp;</p>

              <p><u><strong>2. ATV</strong></u></p>

              <p><strong>What do I need to bring/wear? </strong></p>

              <ul>
                <li>&bull; Quick-dry clothing.</li>
                <li>&bull; covered shoes</li>
                <li>&bull; Straps for eyeglasses/spectacles.</li>
                <li>&bull; Sunblock lotion</li>
                <li>&bull; Set of dry clothes, towel, toiletries, personal medication, and pocket money.</li>
              </ul>

              <p>&nbsp;</p>

              <p><strong>Is there is a place to shower after activity? </strong></p>

              <p>Yes, there are simple communal toilets and cold-water showers available at ADREN X BASE.</p>

              <p><strong>Can I bring my phone or camera? </strong></p>

              <p>Suggested to only bring <strong>waterproof </strong>devices with safety lanyards at your own risk.</p>

              <p><strong>I Have Asthma, Can I Join? </strong></p>

              <p>Yes you can, bring along your inhaler and notify the Guide Master</p>

              <p>&nbsp;</p>

              <p><u><strong>3. Zipline 200 Meter</strong></u></p>

              <p><strong>Maximum weight?</strong></p>

              <p>100 KG.</p>

              <p><strong>Is it safe do this activity? </strong></p>

              <p>Yes it is safe. Every component that we applied for high rope we referred to external auditor from MCCA (Malaysia Challenge Course Association) to check.</p>

              <p><strong>Can I bring my phone or camera? </strong></p>

              <p>Yes with confident or any related devices with safety lanyards in your own risk.</p>

              <p><strong>I Have Asthma, Can I Join? </strong></p>

              <p>Yes you can, bring along your inhaler and notify the Guide Master</p>

              <p>&nbsp;</p>

              <p><u><strong>4. Zipline 1 Km</strong></u></p>

              <p><strong>Maximum weight?</strong></p>

              <p>100 KG.</p>

              <p><strong>Is it safe do this activity? </strong></p>

              <p>Yes it is safe. Every component that we applied for high rope we referred to external auditor from MCCA (Malaysia Challenge Course Association) to check.</p>

              <p><strong>Can I bring my phone or camera? </strong></p>

              <p>Yes with confident or any related devices with safety lanyards in your own risk.</p>

              <p><strong>I Have Asthma, Can I Join? </strong></p>

              <p>Yes you can, bring along your inhaler and notify the Guide Master</p>

              <p>&nbsp;</p>

              ''',

                // all other parameters are optional, a few notable params:

                // specify custom styling for an element
                // see supported inline styling below
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }

                  return null;
                },

                // render a custom widget
                customWidgetBuilder: (element) {
                  return null;
                },

                // these callbacks are called when a complicated element is loading
                // or failed to render allowing the app to render progress indicator
                // and fallback widget
                onErrorBuilder: (context, element, error) =>
                    Text('$element error: $error'),
                onLoadingBuilder: (context, element, loadingProgress) =>
                    CircularProgressIndicator(),

                // this callback will be triggered when user taps a link

                // select the render mode for HTML body
                // by default, a simple `Column` is rendered
                // consider using `ListView` or `SliverList` for better performance
                renderMode: RenderMode.column,

                // set the default styling for text
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5,
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
          ],
        ),
      ),
    );
  }
}
