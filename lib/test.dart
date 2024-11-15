final TextEditingController searchController = TextEditingController();
final FocusNode searchFocusNode = FocusNode(); // Add FocusNode for the search bar
List<QueryDocumentSnapshot> data = [];
List<QueryDocumentSnapshot> filteredData = [];
bool isLoading = true; // Tracks loading state for data fetching

@override
void initState() {
  super.initState();
  getData(); // Fetch data when page loads
  searchController.addListener(() {
    filterSearchResults(searchController.text); // Listen for search query changes
  });
  // Add a listener to the FocusNode to rebuild the widget when focus changes
  searchFocusNode.addListener(() {
    setState(() {});
  });
}

@override
void dispose() {
  // Dispose of the FocusNode and TextEditingController
  searchFocusNode.dispose();
  searchController.dispose(); // Dispose controller when page is closed
  super.dispose();
}

// Fetches data from Firestore
Future<void> getData() async {
  setState(() {
    isLoading = true; // Start loading
  });
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("patients").get();
    setState(() {
      data = querySnapshot.docs; // Store fetched data
      filteredData = data; // Set filtered data to show all patients initially
      isLoading = false; // End loading
    });
  } catch (e) {
    print("Error fetching data: $e");
    setState(() {
      isLoading = false; // Ensure loading stops on error
    });
  }
}

// Filters patient list based on search query
void filterSearchResults(String query) {
  List<QueryDocumentSnapshot> searchResults = [];
  if (query.isEmpty) {
    searchResults = data; // Show all patients if query is empty
  } else {
    searchResults = data.where((patient) {
      String name = patient['name'].toString().toLowerCase();
      return name.startsWith(query.toLowerCase()); // Search by name prefix
    }).toList();
  }
  setState(() {
    filteredData = searchResults; // Update filtered data
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Patients List', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blueAccent,
    ),
    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismisses keyboard on tap outside search bar
      child: RefreshIndicator(
        onRefresh: getData, // Reloads data when user pulls to refresh
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.blue)) // Show loading indicator if data is loading
            : Column(
          children: [
            // Search bar with back and clear icons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FocusScope(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    // Trigger a state update when the TextField is focused/unfocused
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      // Back icon, shown only when search bar is focused
                      if (FocusScope.of(context).hasFocus)
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Unfocus the TextField to hide the keyboard
                            FocusScope.of(context).unfocus();
                            searchFocusNode.unfocus();
                            searchController.clear(); // Clear the search input
                            setState(() {}); // Update the UI
                          },
                        ),
                      // Search text field
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          focusNode: searchFocusNode, // Attach the FocusNode to the TextField
                          onChanged: (value) {
                            // Trigger state update to show or hide "X" icon
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Searching',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear(); // Clear text
                                setState(() {}); // Update the UI to hide "X" icon
                              },
                            )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
