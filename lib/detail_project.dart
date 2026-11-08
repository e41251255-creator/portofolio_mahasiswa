
import 'package:flutter/material.dart';

class DetailProjectPage extends StatelessWidget {
  final Map<String, String> project;

  const DetailProjectPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final nama = project['nama'] ?? 'Tanpa Nama';
    final tahun = project['tahun'] ?? '-';
    final teknologi = project['teknologi'] ?? '-';
    final deskripsi = project['deskripsi'] ?? '-';
    final gambar = project['gambar'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Project'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner atau screenshot proyek
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: gambar.isNotEmpty
                  ? Image.network(
                      gambar,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _gambarPengganti();
                      },
                    )
                  : _gambarPengganti(),
            ),

            const SizedBox(height: 20),

            // Nama proyek
            Text(
              nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _infoProyek(
              Icons.calendar_month,
              'Tahun',
              tahun,
            ),

            const SizedBox(height: 12),

            _infoProyek(
              Icons.code,
              'Teknologi',
              teknologi,
            ),

            const SizedBox(height: 24),

            const Text(
              'Deskripsi Lengkap',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoProyek(
    IconData icon,
    String judul,
    String isi,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(isi),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gambarPengganti() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 60,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 8),
          Text('Screenshot proyek belum tersedia'),
        ],
      ),
    );
  }
}

