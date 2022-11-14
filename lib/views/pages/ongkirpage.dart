part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String dropdownvalue = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic provdataDes;
  dynamic selectedProv;
  dynamic selectedprovDes;

  dynamic cityId;
  dynamic cityData;
  dynamic cityDataDes;
  dynamic selectedCity;
  dynamic selectedcityDes;

  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });
    return listProvince;
  }

  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });
    return listCity;
  }

  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
    provdataDes = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  //Flexible untuk form
                  Flexible(
                    flex: 6,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                              SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: ctrlBerat,
                                    decoration: InputDecoration(
                                      labelText: 'Berat (gr)',
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value == null || value == 0
                                          ? 'Berat harus diisi atau tidak boleh 0!'
                                          : null;
                                    },
                                  ))
                            ],
                          ),
                        ),
                        // Origin Title
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Origin",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),

                        //Origin Province
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: FutureBuilder<List<Province>>(
                                            future: provinceData,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return DropdownButton(
                                                    isExpanded: true,
                                                    value: selectedProv,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    hint: selectedProv == null
                                                        ? Text(
                                                            'Choose Province')
                                                        : Text(selectedProv
                                                            .province),
                                                    items: snapshot.data!.map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province value) {
                                                      return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .province
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedProv = newValue;
                                                        provId = selectedProv
                                                            .provinceId;
                                                      });
                                                      selectedCity = null;
                                                      cityData =
                                                          getCities(provId);
                                                    });
                                              } else if (snapshot.hasError) {
                                                return Text("Tidak ada data.");
                                              }
                                              return UiLoading.loadingDD();
                                            }),
                                      ),
                                      //City Origin
                                      SizedBox(
                                        width: 130,
                                        child: FutureBuilder<List<City>>(
                                            future: cityData,
                                            builder: (context, snapshot) {
                                              if (selectedProv != null) {
                                                if (snapshot.hasData) {
                                                  return DropdownButton(
                                                      isExpanded: true,
                                                      value: selectedCity,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      hint: selectedCity == null
                                                          ? Text('Choose city')
                                                          : Text(selectedCity
                                                              .cityName),
                                                      items: snapshot.data!.map<
                                                              DropdownMenuItem<
                                                                  City>>(
                                                          (City value) {
                                                        return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value
                                                                .cityName
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedCity =
                                                              newValue;
                                                          cityId = selectedCity
                                                              .cityId;
                                                        });
                                                      });
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      "Tidak ada data.");
                                                }
                                                return UiLoading.loadingDD();
                                              } else {
                                                return Text(
                                                    "Choose Province First!",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic));
                                              }
                                            }),
                                      ),
                                    ])
                              ],
                            )),

                        //Destination Section
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Destination",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),

                        //Province Destination
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: FutureBuilder<List<Province>>(
                                            future: provdataDes,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return DropdownButton(
                                                    isExpanded: true,
                                                    value: selectedprovDes,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    hint: selectedprovDes ==
                                                            null
                                                        ? Text(
                                                            'Choose Province')
                                                        : Text(selectedprovDes
                                                            .province),
                                                    items: snapshot.data!.map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province value) {
                                                      return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .province
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedprovDes =
                                                            newValue;
                                                        provId = selectedprovDes
                                                            .provinceId;
                                                      });
                                                      selectedcityDes = null;
                                                      cityDataDes =
                                                          getCities(provId);
                                                    });
                                              } else if (snapshot.hasError) {
                                                return Text("Tidak ada data.");
                                              }
                                              return UiLoading.loadingDD();
                                            }),
                                      ),

                                      //City Destination
                                      SizedBox(
                                        width: 130,
                                        child: FutureBuilder<List<City>>(
                                            future: cityDataDes,
                                            builder: (context, snapshot) {
                                              if (selectedprovDes != null) {
                                                if (snapshot.hasData) {
                                                  return DropdownButton(
                                                      isExpanded: true,
                                                      value: selectedcityDes,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      hint: selectedcityDes ==
                                                              null
                                                          ? Text('Pilih kota')
                                                          : Text(selectedcityDes
                                                              .cityName),
                                                      items: snapshot.data!.map<
                                                              DropdownMenuItem<
                                                                  City>>(
                                                          (City value) {
                                                        return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value
                                                                .cityName
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedcityDes =
                                                              newValue;
                                                          cityId =
                                                              selectedcityDes
                                                                  .cityId;
                                                        });
                                                      });
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      "Tidak ada data.");
                                                }
                                                return UiLoading.loadingDD();
                                              } else {
                                                return Text(
                                                    "Please choose the Province first !",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic));
                                              }
                                            }),
                                      ),
                                    ]),
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (selectedProv == null ||
                                          selectedprovDes == null ||
                                          selectedCity == null ||
                                          selectedcityDes == null) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You must choose destination or origin first!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.redAccent,
                                            textColor: Colors.black);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Origin: ${selectedCity.cityName}' +
                                                ', Destination : ${selectedcityDes.cityName}',
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.greenAccent,
                                            textColor: Colors.black);
                                      }
                                    },
                                    child: Text("Calculate Price Now!"),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),

                  Flexible(
                    flex: 2,
                    child: Container(),
                  )
                ],
              )),
          isLoading == true ? UiLoading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
