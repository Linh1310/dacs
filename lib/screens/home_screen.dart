import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EcoBatHomeScreen extends StatefulWidget {
  const EcoBatHomeScreen({Key? key}) : super(key: key);

  @override
  State<EcoBatHomeScreen> createState() => _EcoBatHomeScreenState();
}

class _EcoBatHomeScreenState extends State<EcoBatHomeScreen> {
  // 1. Tạo "Bộ điều khiển" cho bản đồ
  final MapController _mapController = MapController();

  // 2.Dữ liệu thật từ Google cho các trạm thu gom tại Đà Nẵng
  final List<Map<String, dynamic>> _stations = [
    {
      'name': 'Hasaki Beauty & Clinic',
      'address': '393 Lê Duẩn, Thanh Khê',
      'location': const LatLng(16.0683, 108.2121),
      'time': '09:00 - 20:00',
      'note': 'Thu gom các loại pin cũ, rác thải điện tử nhỏ'
    },
    {
      'name': 'Trung tâm Anh ngữ - FEC Central (Cơ sở 1)',
      'address': '108 Phan Châu Trinh, Hải Châu',
      'location': const LatLng(16.0663, 108.2202),
      'time': '08:00 - 20:00',
      'note': 'Điểm Ngôi nhà của pin'
    },
    {
      'name': 'Trung tâm Anh ngữ - FEC East (Cơ sở 2)',
      'address': '808 Ngô Quyền, Sơn Trà',
      'location': const LatLng(16.0694, 108.2328),
      'time': '08:00 - 20:00',
      'note': 'Điểm Ngôi nhà của pin'
    },
    {
      'name': 'Green Da Nang',
      'address': '35 Chế Lan Viên, Ngũ Hành Sơn',
      'location': const LatLng(16.0401, 108.2455),
      'time': 'Chủ nhật hàng tuần',
      'note': 'Trạm gửi rác tái chế'
    },
    {
      'name': 'Ngân hàng OCB (Chi nhánh Xanh)',
      'address': 'Chi nhánh trung tâm Đà Nẵng',
      'location': const LatLng(16.0605, 108.2235),
      'time': 'Giờ hành chính',
      'note': 'Đổi quà khi mang trên 20 viên pin'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // LỚP 1: BẢN ĐỒ
          FlutterMap(
            mapController: _mapController, // Gắn bộ điều khiển vào đây
            options: const MapOptions(
              initialCenter: LatLng(16.0544, 108.2022), // Tọa độ mặc định
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                //CartoDB có một bộ bản đồ tên là Voyager (tông màu sáng, đường viền mềm, có sẵn mảng xanh của cây cỏ rất đẹp)
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              // Lấy dữ liệu từ danh sách _stations để tự động rải Marker lên bản đồ
              MarkerLayer(
                markers: _stations.map((station) {
                  return Marker(
                    point: station['location'],
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.battery_charging_full,
                      color: Color(0xFF2E8B57), // Màu SeaGreen
                      size: 40,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // LỚP 2: Thanh tìm kiếm (Giữ nguyên)
          Positioned(
            top: 50.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm điểm thu gom pin gần bạn...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF3CB371)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // LỚP 3: Thẻ danh sách trạm
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _stations.length, // Đếm số lượng trạm trong dữ liệu
                  itemBuilder: (context, index) {
                    final station = _stations[index]; // Lấy thông tin trạm hiện tại
                    return ListTile(
                      leading: const Icon(Icons.battery_charging_full, color: Color(0xFF2E8B57)),
                      title: Text(station['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Mở cửa: ${station['time']}\nCách đây: ${station['distance']}'),
                      trailing: const Icon(Icons.my_location, color: Color(0xFF20B2AA)),

                      // SỰ KIỆN QUAN TRỌNG: Khi bấm vào 1 trạm
                      onTap: () {
                        // Ra lệnh cho bản đồ di chuyển đến tọa độ của trạm đó, zoom lại gần (mức 16.0)
                        _mapController.move(station['location'], 16.0);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),

      // LỚP 4: Nút Quét QR (Giữ nguyên)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () { print("Chuyển sang màn hình quét QR Code!"); },
        label: const Text('Quét QR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        backgroundColor: const Color(0xFF2E8B57),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}