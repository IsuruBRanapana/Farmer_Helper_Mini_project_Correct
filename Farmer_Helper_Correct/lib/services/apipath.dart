class APIPath{
  static String cultivationType(String uid,String jobId)=>'users/$uid/cultivationType/$jobId';
  static String cultivationTypes(String uid)=>'users/$uid/cultivationType';
  static String cultivationProblem(String uid, String entryId)=>'users/$uid/cultivationProblems/$entryId';
  static String cultivationProblems(String uid)=>'users/$uid/cultivationProblems';
}