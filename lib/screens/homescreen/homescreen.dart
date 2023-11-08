import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trustdine_kds/backend/api_data.dart';
import 'package:trustdine_kds/backend/central_api.dart';
import 'package:trustdine_kds/main.dart';
import 'package:trustdine_kds/screens/Auth/login.dart';
import 'package:trustdine_kds/storage/cache.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  bool _isError = false;
  String _error = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      List<dynamic> fetchedOrders = await fetchOrders();
      setState(() {
        orders = fetchedOrders;
        _isLoading = false;
        // _isError = false;
      });
      // print('Fetched Orders: $orders');
    } catch (e) {
      setState(() {
        _isLoading = false; // Error occurred while loading data
        _error = 'Error fetching orders: $e';
        _isError = true;
      });
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Please connect to the internet"),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ));
                },
                child: const Text("Refresh"),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  )); */
              Fluttertoast.showToast(msg: "Refresh in progress.");
              orders = await fetchOrders();
              setState(() {});
              Fluttertoast.cancel();
              Fluttertoast.showToast(msg: "Refresh Successfull.");
            },
          ),
          title: const Text("Orders"),
          centerTitle: true,
          backgroundColor: Colors.grey.shade50,
          foregroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await SecureStorageManager.deleteToken();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
            ),
          ],
        ),
        body: orders.length > 0
            ? SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      orders.length,
                      (index) => Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ExpansionTile(
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              title: Text(
                                'Order #${orders[index]['orderId']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(bottom: 7.0),
                                child: IconButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                        orders[index]['orderId'],
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 35,
                                    )),
                              ),
                              subtitle:
                                  Text("Ordered at ${orders[index]['time']}"),
                              expandedAlignment: Alignment.topLeft,
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black87,
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () {},
                              // ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showDeleteConfirmationDialog(
                                            orders[index]['orderId'],
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Mark as Completed",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Items in this order:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: List.generate(
                                          orders[index]["OrderItems"].length,
                                          (itemIndex) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ListTile(
                                              tileColor: Colors.grey.shade100,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              minVerticalPadding: 0,
                                              // contentPadding: const EdgeInsets.all(0),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  // height: screenWidth / 4,
                                                  width: screenWidth / 4,
                                                  child: CachedNetworkImage(
                                                    imageUrl: orders[index]
                                                            ["OrderItems"]
                                                        [itemIndex]['foodImg'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                  "${orders[index]["OrderItems"][itemIndex]['foodName']}"),
                                              subtitle: Text(
                                                "${orders[index]["OrderItems"][itemIndex]['foodSize']}  -  ${orders[index]["OrderItems"][itemIndex]['foodType']}\nQuantity: ${orders[index]["OrderItems"][itemIndex]['foodQuantity']}",
                                              ),
                                              isThreeLine: true,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                ),
              )
            : const Center(
                child: Text("No Orders Found!"),
              ),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(String orderId) async {
    bool confirmDelete = false;

    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete order #$orderId?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                confirmDelete = true;
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      // Call your deleteOrder function here
      // await deleteOrder(orderId);
      // Perform the deletion logic and refresh the orders
      Fluttertoast.showToast(msg: "Deleting order #$orderId");
      final response = await deleteOrder(orderId);
      orders = await fetchOrders();
      setState(() {});
      Fluttertoast.showToast(msg: "Order #$orderId deleted successfully.");
    }
  }
}
