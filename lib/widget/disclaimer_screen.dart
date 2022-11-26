import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({Key? key}) : super(key: key);

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
        "DISCLAIMER",
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
             <p>** The suitability for Activiti depends on the weather forecast. If heavily rain we need to stop as soon as possible .&nbsp;**<br /></p>
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
              height: 10,
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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
