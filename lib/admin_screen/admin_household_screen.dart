import 'package:flutter/material.dart';
import 'fetch_service.dart'; // Ensure this path matches your project structure

class Household {
  final String id;
  final String headName;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String taluk;
  final String nagara;
  final String ward;
  final String pincode;
  final String fullAddress;
  final int familyMembersCount;

  Household({
    required this.id,
    required this.headName,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    required this.taluk,
    required this.nagara,
    required this.ward,
    required this.pincode,
    required this.fullAddress,
    required this.familyMembersCount,
  });
}

class AdminHouseholdScreen extends StatefulWidget {
  const AdminHouseholdScreen({super.key});

  @override
  State<AdminHouseholdScreen> createState() => _AdminHouseholdScreenState();
}

class _AdminHouseholdScreenState extends State<AdminHouseholdScreen> {
  // Data State
  List<Household> _allHouseholds = [];
  List<Household> _filteredList = [];
  bool _isLoading = true;
  bool _isFilterExpanded = true;

  // Filter Variables
  String _selectedCountry = 'India';
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluk;
  String? _selectedNagara;
  String? _selectedWard;
  final TextEditingController _searchController = TextEditingController();

  // Location Data (Used for Dropdowns)
  final List<String> _countries = ['India', 'USA', 'UK'];
  final Map<String, List<String>> _stateDistrictMap = {
    'Karnataka': ['Bangalore', 'Mysore', 'Davangere', 'Hubli', 'Shimoga'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
  };
  final Map<String, List<String>> _districtTalukMap = {
    'Bangalore': ['Bangalore North', 'Bangalore South', 'Anekal'],
    'Mysore': ['Mysore', 'K.R. Nagar', 'T. Narasipura'],
    'Davangere': ['Davangere', 'Harihar', 'Jagalur', 'Channagiri'],
  };
  final List<String> _nagaraList = ['Nagara 1', 'Nagara 2', 'Nagara 3', 'Nagara 4', 'Nagara 5'];
  final List<String> _wardList = ['Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5', 'Ward 6', 'Ward 7', 'Ward 8'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // --- Supabase Data Logic ---
  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    // Fetch flattened rows from the database view
    final List<Map<String, dynamic>> data = await SupabaseService.fetchAdminDashboardData();

    // Group rows by household_id
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var row in data) {
      String id = row['household_id'];
      groupedData.putIfAbsent(id, () => []).add(row);
    }

    List<Household> tempHouseholds = [];
    groupedData.forEach((householdId, members) {
      // Find the row where is_head is true, or default to the first member
      final headRow = members.firstWhere(
            (m) => m['is_head'] == true,
        orElse: () => members.first,
      );

      tempHouseholds.add(Household(
        id: householdId,
        headName: headRow['name'] ?? 'Unknown',
        mobile: headRow['mobile_number'] ?? 'N/A',
        country: headRow['country'] ?? 'India',
        state: headRow['state'] ?? '',
        district: headRow['district'] ?? '',
        taluk: headRow['taluk'] ?? '',
        nagara: headRow['nagara'] ?? '',
        ward: headRow['ward'] ?? '',
        pincode: headRow['pincode'] ?? '',
        fullAddress: "${headRow['ward']}, ${headRow['nagara']}, ${headRow['taluk']}",
        familyMembersCount: members.length,
      ));
    });

    setState(() {
      _allHouseholds = tempHouseholds;
      _isLoading = false;
      _runFilter();
    });
  }

  // --- Filter Logic ---
  void _runFilter() {
    setState(() {
      _filteredList = _allHouseholds.where((item) {
        bool countryMatch = item.country == _selectedCountry;
        bool stateMatch = _selectedState == null || item.state == _selectedState;
        bool districtMatch = _selectedDistrict == null || item.district == _selectedDistrict;
        bool talukMatch = _selectedTaluk == null || item.taluk == _selectedTaluk;
        bool nagaraMatch = _selectedNagara == null || item.nagara == _selectedNagara;
        bool wardMatch = _selectedWard == null || item.ward == _selectedWard;

        String search = _searchController.text.toLowerCase();
        bool textMatch = search.isEmpty ||
            item.headName.toLowerCase().contains(search) ||
            item.pincode.contains(search);

        return countryMatch && stateMatch && districtMatch && talukMatch &&
            nagaraMatch && wardMatch && textMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCountry = 'India';
      _selectedState = null;
      _selectedDistrict = null;
      _selectedTaluk = null;
      _selectedNagara = null;
      _selectedWard = null;
      _searchController.clear();
      _runFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // --- FILTER SECTION ---
          _buildFilterWidget(),

          const Divider(height: 1),

          // --- LIST SECTION ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.blueGrey))
                : RefreshIndicator(
              onRefresh: _fetchData,
              child: _filteredList.isEmpty
                  ? const Center(child: Text("No records found.", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _filteredList.length,
                itemBuilder: (context, index) => _buildHouseholdCard(_filteredList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BUILDING BLOCKS ---

  Widget _buildFilterWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isFilterExpanded = !_isFilterExpanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.blueGrey[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("${_filteredList.length} households found", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  _buildTotalBadge(),
                  Icon(_isFilterExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.blueGrey[700]),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isFilterExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildFilterPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBadge() {
    int totalPeople = _filteredList.fold(0, (sum, item) => sum + item.familyMembersCount);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.people, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text("$totalPeople", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: _inputDecoration("Search Name or Pincode...").copyWith(prefixIcon: const Icon(Icons.search)),
            onChanged: (val) => _runFilter(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDropdown("Country", _countries, _selectedCountry, (v) => setState(() { _selectedCountry = v!; _selectedState = null; _runFilter(); }))),
              const SizedBox(width: 10),
              Expanded(child: _buildDropdown("State", _stateDistrictMap.keys.toList(), _selectedState, (v) => setState(() { _selectedState = v; _selectedDistrict = null; _runFilter(); }))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDropdown("District", _selectedState == null ? [] : _stateDistrictMap[_selectedState]!, _selectedDistrict, (v) => setState(() { _selectedDistrict = v; _selectedTaluk = null; _runFilter(); }))),
              const SizedBox(width: 10),
              Expanded(child: _buildDropdown("Taluk", _selectedDistrict == null ? [] : _districtTalukMap[_selectedDistrict] ?? [], _selectedTaluk, (v) => setState(() { _selectedTaluk = v; _runFilter(); }))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Reset Filters"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: BorderSide(color: Colors.red.shade100)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdCard(Household item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blueGrey[50], child: Text(item.headName[0].toUpperCase())),
        title: Text(item.headName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item.district}, ${item.state} | Members: ${item.familyMembersCount}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => _showDetailsDialog(item),
      ),
    );
  }

  void _showDetailsDialog(Household item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.headName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow("Mobile", item.mobile),
              _detailRow("Taluk", item.taluk),
              _detailRow("Nagara", item.nagara),
              _detailRow("Ward", item.ward),
              _detailRow("Pincode", item.pincode),
              _detailRow("Total Size", "${item.familyMembersCount}"),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}