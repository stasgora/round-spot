class SyncFrequency {
  const SyncFrequency() : this.countBased(1);
  const SyncFrequency.timeBased(Duration frequency, {int? minSessionCount});
  const SyncFrequency.countBased(int sessionCount, {Duration? minFrequency});

  SyncFrequency.fromJson(Map<String, dynamic> json);
}
