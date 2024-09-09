import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';

class SubscriberListPage extends StatefulWidget {
  @override
  _SubscriberListPageState createState() => _SubscriberListPageState();
}

class _SubscriberListPageState extends State<SubscriberListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Subscriber>> _fetchSubscribers() {
    return _firestore.collection('subscription_request').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Subscriber.fromFirestore(doc)).toList();
    });
  }

  Future<void> _approveSubscription(String docId,String userId,String duration) async {
   await _firestore.collection('subscription_request').doc(docId).update({'status': 'APPROVED'});
   var temp=int.parse(duration)*30;
   await _firestore.collection("users").doc(userId).set({
     "subscription_active":true,
     "Subscription_start": DateTime.now(),
     "duration": temp
   });

    
  }

  Future<void> _cancelSubscription(String docId,userId) async {
    await  _firestore.collection('subscription_request').doc(docId).update({'status': 'CANCELED'});
    
   var temp= await _firestore.collection("users").doc(userId).collection("subscription").doc(userId).get();

   if(temp.exists){
     await _firestore.collection("users").doc(userId).update({
       "subscription_active":false,
     });
   }


  }

  void _copyTransactionId(String transactionId) {
    Clipboard.setData(ClipboardData(text: transactionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction ID copied to clipboard")),
    );
  }
  void _viewImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullImageView(imageUrl: imageUrl),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'CANCELED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscribers"),
        backgroundColor: Color(0xFF66B2B2),
      ),
      body: StreamBuilder<List<Subscriber>>(
        stream: _fetchSubscribers(),
        builder: (context, AsyncSnapshot<List<Subscriber>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }

          final subscribers = snapshot.data ?? [];

          if (subscribers.isEmpty) {
            return Center(child: Text("No subscribers available"));
          }

          return ListView.builder(
            itemCount: subscribers.length,
            itemBuilder: (context, index) {
              final subscriber = subscribers[index];
              final docId = snapshot.data![index].id;

              return FractionallySizedBox(
                widthFactor: 0.85,  // Setting width to 85% of screen size
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,

                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(subscriber.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                subscriber.status,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            "User name: ${subscriber.userName}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Package Duration: ${subscriber.packageDuration}"),
                        Text("Package Price: ${subscriber.packagePrice}"),
                        Text("Created At: ${subscriber.createdAt.toLocal()}"),
                        SizedBox(height: 10),

                        Row(
                          children: [
                            Text("Transaction ID: ${subscriber.transactionId}"),
                            IconButton(
                              icon: Icon(Icons.copy, color: Colors.blue),
                              onPressed: () => _copyTransactionId(subscriber.transactionId),
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () => _viewImage(subscriber.screenshotUrl),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              subscriber.screenshotUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),


                        SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _approveSubscription(docId,subscriber.userId,subscriber.packageDuration.split(" ").first),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Approve"),
                            ),
                            ElevatedButton(
                              onPressed: () => _cancelSubscription(docId,subscriber.userId),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Subscriber {
  final String userId;
  final String id;
  final String userName;
  final String transactionId;
  final String screenshotUrl;
  final String packageDuration;
  final String packagePrice;
  final DateTime createdAt;
  final String status;

  Subscriber({
    required this.userId,
    required this.id,
    required this.userName,
    required this.transactionId,
    required this.screenshotUrl,
    required this.packageDuration,
    required this.packagePrice,
    required this.createdAt,
    required this.status,
  });

  factory Subscriber.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Subscriber(
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      id: data['id'] ?? '',
      transactionId: data['transaction_id'] ?? '',
      screenshotUrl: data['screenshot'] ?? '',
      packageDuration: data['package_duration'] ?? '',
      packagePrice: data['package_price'] ?? '',
      createdAt: (data['create_at'] as Timestamp).toDate(),
      status: data['status'] ?? 'PENDING',
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  FullImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Image"),
        backgroundColor: Color(0xFF66B2B2),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
