import 'package:flutter/material.dart';
import 'dart:math';
import '../model/job.dart';
import 'package:animate_do/animate_do.dart';

class JobDialog extends StatefulWidget {
  final Job? job;
  final Function(
      String name, double brut, double net, String statut, String comment)
  onClickedDone;

  const JobDialog({
    Key? key,
    this.job,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _JobDialogState createState() => _JobDialogState();
}

class _JobDialogState extends State<JobDialog> {
  final formKey = GlobalKey<FormState>();
  final horaireBrutController = TextEditingController();
  final horaireNetController = TextEditingController();
  final annuelBrutController = TextEditingController();
  final annuelNetController = TextEditingController();
  final mensuelBrutController = TextEditingController();
  final mensuelNetController = TextEditingController();


  final prelevementController = TextEditingController();
  final annuelImpotController = TextEditingController();
  final mensuelImpotController = TextEditingController();
  final tempsController = TextEditingController();

  final items = [
    'Salarié non-cadre 22%',
    'Salarié cadre 25%',
    'Fonction publique 15%',
    'Profession libérale 45%',
    'Portage salarial 51%'
  ];

  final itemsPrime = [
    '12 mois',
    '13 mois',
    '14 mois',
    '15 mois',
    '16 mois'
  ];
  final pourcentages = [0.78, 0.75, 0.85, 0.55, 0.49];

  String? dropdownValue = 'Salarié non-cadre 22%';

  String? dropdownPrimeValue = '12 mois';
  int dropdownPrimeIndex = 0;
  int dropdownIndex = 0;



  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double calculSalaire(double salaire, bool isBrut, double pourcentage) {
    if (!isBrut) {
      pourcentage += 1;
    }

    return roundDouble(salaire * pourcentage, 2);
  }

  onInputChange() {
    setState(() {
      double? horairebrut = double.tryParse(horaireBrutController.text);
      double horairenet = 0;
      double? mensuelbrut = double.tryParse(mensuelBrutController.text);
      double mensuelnet = 0;
      double? annuelbrut = double.tryParse(annuelBrutController.text);
      double annuelnet = 0;
      if (horairebrut != null) {
        horairenet = calculSalaire(horairebrut/1.0001, true, pourcentages[dropdownIndex]);
      }

      if (horairenet >= 0) {
        horaireNetController.text = horairenet.toString();
        horaireBrutController.text = horairebrut.toString();
        mensuelNetController.text = mensuelnet.toString();
        mensuelBrutController.text = mensuelbrut.toString();
        annuelNetController.text = annuelnet.toString();
        annuelBrutController.text = annuelbrut.toString();
      }
    });
  }

  onNetChange() {
    setState(() {
      double? horairenet = double.tryParse(horaireNetController.text);
      double horairebrut = 0;
      if (horairenet != null) {
        horairebrut = calculSalaire(horairenet, false, pourcentages[dropdownIndex]);
      }
      if (horairebrut >= 0) {
        horaireBrutController.text = horairebrut.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.job != null) {
      final job = widget.job!;


      annuelBrutController.text = job.comment;

      dropdownValue = job.statut;
      dropdownIndex = items.indexOf(dropdownValue!);
    }
  }

  @override
  void dispose() {
    horaireBrutController.dispose();
    horaireNetController.dispose();
    mensuelBrutController.dispose();
    mensuelNetController.dispose();
    annuelBrutController.dispose();
    annuelNetController.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.job != null;
    final title =
    isEditing ? 'Editer une offre' : 'Calcul du salaire Brut en Net';

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: SingleChildScrollView(
        //Animation de chutte
        child: BounceInDown(
          child:
          Row(
            children: [
            Container(
            height: 500,
            width: 500,
            //Maximum de l'espace disponible
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //Axe horizental
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children:[
                  SizedBox(width: 40),
                  Text(
                  "INDIQUEZ VOTRE SALAIRE BRUT",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                  SizedBox(width: 55),
                  Text(
                    "RESULTAT DE VOTRE SALAIRE NET",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),



                ],
                ),

                SizedBox(height: 20),

                Container(
                  //Division des champs

                    child: Column(

                      children: [

                        Row(children: [
                          Container(
                              width: 230,
                              child: Column(children: [
                                buildHoraireBrut(),
                                SizedBox(height: 20),
                                buildNet(),
                                SizedBox(height: 20),
                                buildAnnuelBrut(),
                              ])),
                          Container(
                              width: 230,
                              child: Column(children: [
                                buildHoraireNet(),
                                SizedBox(height: 20),
                                buildMensuelNet(),
                                SizedBox(height: 20),
                                buildAnnuelNet(),
                              ])),
                        ]
                        )

                      ],
                    )),
                SizedBox(height: 20),

                //Champ large
                Expanded(child: buildStatut()),
              ],
            ),
          ),
          Container(
              height: 500,
              width: 500,
              //Maximum de l'espace disponible
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //Axe horizental
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children:[
                    SizedBox(width: 40),
                    Text(
                      "INDIQUEZ VOTRE TEMPS DE TRAVAIL",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ]),


              SizedBox(height: 20),
              Container(
                  width: 500,
                  child: buildTemps()
              ),
              SizedBox(height: 20),
              Container(
                  width: 500,
                  child: buildPrime()
              ),
              SizedBox(height: 20),
              Container(
                  width: 500,
                  child: buildPrelevement()
              ),
              SizedBox(height: 20),
              Container(
                  width: 500,
                  child: Column(
                      children: [
                  Row(
                  children:[
                  Container(
                      width: 230,
                      child: Column(children: [
                        buildMensuelImpot(),
                      ])),
                    SizedBox(height: 20),
                  Container(
                      width: 230,
                      child: Column(
                          children: [
                            buildAnnuelImpot(),
                          ])
                  ),


                  ]
              )]

          ),

        ),
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,


                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child:Text("Effacer les champs", style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,

                            ),
                          ),



                        ]

                    ),

                  ),


        ],
      ),
    ),
    ]),
    )),
    );
  }

  Widget buildHoraireNet() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.timer, color: Colors.white),
            labelText: 'Horaire Net',
            suffixText: "",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: horaireNetController,
      );
  Widget buildHoraireBrut() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.timer, color: Colors.white),
            labelText: 'Horaire Brut',
            suffixText: "",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: horaireBrutController,
      );

  Widget buildMensuelImpot() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Mensuel net après impôts',
            suffixText: "",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: mensuelImpotController,
      );
  Widget buildAnnuelImpot() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Annuel net après impôts',
            suffixText: "€",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: annuelImpotController,
      );
  Widget buildTemps() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.timer, color: Colors.white),
            labelText: 'Temps de travail',
            suffixText: "",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: tempsController,
      );

  Widget buildPrime() =>
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.add, color: Colors.white),
            labelText: 'Prime',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        value: dropdownPrimeValue,
        items: itemsPrime.map(builMenuItem).toList(),
        onChanged: (value) =>
            setState(() {
              if (value != null) {
                dropdownPrimeValue = value;
                dropdownPrimeIndex = itemsPrime.indexOf(value);
              }
              onInputChange();
            }),
        validator: (name) => name != null && name.isEmpty ? 'Statut' : null,
      );

  Widget buildPrelevement() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.percent, color: Colors.white),
            labelText: 'Taux de prélevement à la source',
            suffixText: "%",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: prelevementController,
      );

  Widget buildMensuelNet() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Mensuel Net',
            suffixText: "€",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: mensuelNetController,
      );
  Widget buildNet() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Mensuel Brut',
            suffixText: "€",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: mensuelBrutController,
      );



  Widget buildAnnuelNet() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Annuel Net',
            suffixText: "€",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: annuelNetController,
      );
  Widget buildAnnuelBrut() =>
      TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.euro, color: Colors.white),
            labelText: 'Annuel Brut',
            suffixText: "€",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text) {
          onInputChange();
        },
        controller: annuelBrutController,
      );

  DropdownMenuItem<String> builMenuItem(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  Widget buildStatut() =>
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.account_circle, color: Colors.white),
            labelText: 'Statut',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true),
        value: dropdownValue,
        items: items.map(builMenuItem).toList(),
        onChanged: (value) =>
            setState(() {
              if (value != null) {
                dropdownValue = value;
                dropdownIndex = items.indexOf(value);
              }
              onInputChange();
            }),
        validator: (name) => name != null && name.isEmpty ? 'Statut' : null,
      );
}
