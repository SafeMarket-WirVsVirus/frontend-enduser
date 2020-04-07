import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/ui_imports.dart';

import 'about_page_section_licenses.dart';
import 'about_page_section_the_app.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int selectedSectionId = 0;
  List<AboutSection> data;

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      data = [
        AboutSection(
          title: "The App",
          id: 0,
          body: AboutTheAppSection(),
        ),
        AboutSection(
          title: "Licenses",
          id: 1,
          body: SectionLicenses(),
        ),
        AboutSection(
          title: "Another Section",
          id: 2,
          body: Text("body"),
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                selectedSectionId = data[index].id;
              });
            },
            children: data.map<ExpansionPanel>((section) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      section.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: section.body,
                ),
                isExpanded: section.id == selectedSectionId,
              );
            }).toList()),
      ),
    );
  }
}

class AboutPanel extends StatefulWidget {
  @override
  _AboutPanelState createState() => _AboutPanelState();
}

class _AboutPanelState extends State<AboutPanel> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AboutSection {
  String title;
  int id;
  Widget body;

  AboutSection({@required this.title, @required this.id, @required this.body});
}
