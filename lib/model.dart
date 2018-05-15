class Entry {
  String documentId;
  String name;
  String phone;
  String email;
  String signIn;
  String signOut;


  Entry(this.documentId,this.name, this.phone, this.email, this.signIn, this.signOut);
}

// TODO: Handle duplicate names... maybe phone number could be distinct or email
// and one of those must be present...