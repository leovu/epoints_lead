import 'package:flutter/material.dart';

class UpdateContractScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật ca vụ HD SGH 123456'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Thông tin HD'),
            SizedBox(height: 16),
            ContractInfoCard(),
            SizedBox(height: 16),
            ContactInfoCard(),
            SizedBox(height: 16),
            IssueStatusDropdown(),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SectionTab(title: 'Thông tin bảo trì'),
            SectionTab(title: 'Thanh Toán'),
          ],
        )
      ],
    );
  }
}

class SectionTab extends StatelessWidget {
  final String title;

  const SectionTab({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ContractInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: 'Số HD:', value: 'SGH290453'),
            SizedBox(height: 8),
            InfoRow(label: 'Hạng Vụ:', value: 'Hạng Vàng'),
            SizedBox(height: 8),
            InfoRow(label: 'Internet:', value: 'Gói GIA'),
            SizedBox(height: 8),
            InfoRow(label: 'Tình trạng:', value: 'Bình thường'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: 'Họ Tên:', value: 'NGUYỄN VĂN ANH NGUYỄN'),
            SizedBox(height: 8),
            Text(
              'Địa chỉ: Toà nhà 1TD Số 1, Đường Sáng Tạo, P. Tân Thuận Đông, Quận 7, TPHCM...',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 8),
            InfoRow(label: 'Số điện thoại:', value: '0979307039'),
            SizedBox(height: 8),
            InfoRow(label: 'Liên hệ thường xuyên:', value: '0979307039'),
            SizedBox(height: 8),
            InfoRow(label: 'Tình trạng hiện tại:', value: 'Đang hoạt động'),
          ],
        ),
      ),
    );
  }
}

class IssueStatusDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Nguyên nhân lỗi:',
              border: OutlineInputBorder(),
            ),
            items: ['Tình trạng sự cố ban đầu']
                .map((item) => DropdownMenuItem<String>(
                      child: Text(item),
                      value: item,
                    ))
                .toList(),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}