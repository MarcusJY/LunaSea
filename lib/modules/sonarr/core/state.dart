import 'package:lunasea/core.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrState extends LunaGlobalState {
    SonarrState() {
        reset();
    }
    
    @override
    void reset() {
        // Reset stored data
        _series = null;
        _missing = null;
        _upcoming = null;
        _history = null;
        _qualityProfiles = null;
        _languageProfiles = null;
        _tags = null;
        _episodes = {};
        _selectedEpisodes = [];
        // Reset search query fields (except the home screen)
        _addSearchQuery = '';
        _releasesSearchQuery = '';
        // Reinitialize
        resetProfile();
        resetSeries();
        resetUpcoming();
        resetMissing();
        resetHistory();
        resetQualityProfiles();
        resetLanguageProfiles();
        resetTags();
        notifyListeners();
    }

    ///////////////
    /// PROFILE ///
    ///////////////

    /// API handler instance
    Sonarr _api;
    Sonarr get api => _api;

    /// Is the API enabled?
    bool _enabled;
    bool get enabled => _enabled;
    
    bool _enableVersion3;
    bool get enableVersion3 => _enableVersion3;

    /// Sonarr host
    String _host;
    String get host => _host;

    /// Sonarr API key
    String _apiKey;
    String get apiKey => _apiKey;

    /// Headers to attach to all requests
    Map<dynamic, dynamic> _headers;
    Map<dynamic, dynamic> get headers => _headers;

    /// Reset the profile data, reinitializes API instance
    void resetProfile() {
        ProfileHiveObject _profile = Database.currentProfileObject;
        // Copy profile into state
        _enabled = _profile.sonarrEnabled ?? false;
        _enableVersion3 = _profile.sonarrVersion3 ?? false;
        _host = _profile.sonarrHost ?? '';
        _apiKey = _profile.sonarrKey ?? '';
        _headers = _profile.sonarrHeaders ?? {};
        // Create the API instance if Sonarr is enabled
        _api = _enabled
            ? Sonarr(
                host: _host,
                apiKey: _apiKey,
                headers: Map<String, dynamic>.from(_headers),
            )
            : null;
    }

    ////////////////
    /// EPISODES ///
    ////////////////
    
    Map<int, Future<List<SonarrEpisode>>> _episodes = {};
    Map<int, Future<List<SonarrEpisode>>> get episodes => _episodes;
    void fetchEpisodes(int seriesId) {
        assert(seriesId != null);
        if(_api != null)
            _episodes[seriesId] = _api.episode.getSeriesEpisodes(seriesId: seriesId);
        notifyListeners();
    }

    List<int> _selectedEpisodes = [];
    List<int> get selectedEpisodes => _selectedEpisodes;
    set selectedEpisodes(List<int> selectedEpisodes) {
        assert(selectedEpisodes != null);
        _selectedEpisodes = selectedEpisodes;
        notifyListeners();
    }

    void addSelectedEpisode(int id) {
        if(!_selectedEpisodes.contains(id)) _selectedEpisodes.add(id);
        notifyListeners();        
    }

    void removeSelectedEpisode(int id) {
        if(_selectedEpisodes.contains(id)) _selectedEpisodes.remove(id);
        notifyListeners();
    }

    void toggleSelectedEpisode(int id) {
        _selectedEpisodes.contains(id)
            ? _selectedEpisodes.remove(id)
            : _selectedEpisodes.add(id);
        notifyListeners();
    }

    //////////////////
    /// ADD SERIES ///
    //////////////////

    String _addSearchQuery = '';
    String get addSearchQuery => _addSearchQuery;
    set addSearchQuery(String addSearchQuery) {
        assert(addSearchQuery != null);
        _addSearchQuery = addSearchQuery;
        notifyListeners();
    }

    Future<List<SonarrSeriesLookup>> _seriesLookup;
    Future<List<SonarrSeriesLookup>> get seriesLookup => _seriesLookup;
    void fetchSeriesLookup() {
        if(_api != null)
            _seriesLookup = _api.seriesLookup.getSeriesLookup(term: _addSearchQuery);
        notifyListeners();
    }

    Future<List<SonarrRootFolder>> _rootFolders;
    Future<List<SonarrRootFolder>> get rootFolders => _rootFolders;
    void fetchRootFolders() {
        if(_api != null)
            _rootFolders = _api.rootFolder.getRootFolders();
        notifyListeners();
    }

    ////////////////
    /// RELEASES ///
    ////////////////

    String _releasesSearchQuery = '';
    String get releasesSearchQuery => _releasesSearchQuery;
    set releasesSearchQuery(String releasesSearchQuery) {
        assert(releasesSearchQuery != null);
        _releasesSearchQuery = releasesSearchQuery;
        notifyListeners();
    }

    SonarrReleasesHiding _releasesHidingType = SonarrReleasesHiding.ALL;
    SonarrReleasesHiding get releasesHidingType => _releasesHidingType;
    set releasesHidingType(SonarrReleasesHiding releasesHidingType) {
        assert(releasesHidingType != null);
        _releasesHidingType = releasesHidingType;
        notifyListeners();
    }

    SonarrReleasesSorting _releasesSortType = SonarrReleasesSorting.WEIGHT;
    SonarrReleasesSorting get releasesSortType => _releasesSortType;
    set releasesSortType(SonarrReleasesSorting releasesSortType) {
        assert(releasesSortType != null);
        _releasesSortType = releasesSortType;
        notifyListeners();
    }

    bool _releasesSortAscending = true;
    bool get releasesSortAscending => _releasesSortAscending;
    set releasesSortAscending(bool releasesSortAscending) {
        assert(releasesSortAscending != null);
        _releasesSortAscending = releasesSortAscending;
        notifyListeners();
    }

    //////////////
    /// SERIES ///
    //////////////

    String _seriesSearchQuery = '';
    String get seriesSearchQuery => _seriesSearchQuery;
    set seriesSearchQuery(String seriesSearchQuery) {
        assert(seriesSearchQuery != null);
        _seriesSearchQuery = seriesSearchQuery;
        notifyListeners();
    }

    SonarrSeriesSorting _seriesSortType = SonarrSeriesSorting.ALPHABETICAL;
    SonarrSeriesSorting get seriesSortType => _seriesSortType;
    set seriesSortType(SonarrSeriesSorting seriesSortType) {
        assert(seriesSortType != null);
        _seriesSortType = seriesSortType;
        notifyListeners();
    }

    SonarrSeriesHiding _seriesHidingType = SonarrSeriesHiding.ALL;
    SonarrSeriesHiding get seriesHidingType => _seriesHidingType;
    set seriesHidingType(SonarrSeriesHiding seriesHidingType) {
        assert(seriesHidingType != null);
        _seriesHidingType = seriesHidingType;
        notifyListeners();
    }

    bool _seriesSortAscending = true;
    bool get seriesSortAscending => _seriesSortAscending;
    set seriesSortAscending(bool seriesSortAscending) {
        assert(seriesSortAscending != null);
        _seriesSortAscending = seriesSortAscending;
        notifyListeners();
    }
    
    Future<List<SonarrSeries>> _series;
    Future<List<SonarrSeries>> get series => _series;
    set series(Future<List<SonarrSeries>> series) {
        assert(series != null);
        _series = series;
        notifyListeners();
    }

    void resetSeries() {
        if(_api != null) _series = _api.series.getAllSeries();
        notifyListeners();
    }

    ///////////////
    /// MISSING ///
    ///////////////
    
    Future<SonarrMissing> _missing;
    Future<SonarrMissing> get missing => _missing;
    set missing(Future<SonarrMissing> missing) {
        assert(missing != null);
        _missing = missing;
        notifyListeners();
    }

    void resetMissing() {
        if(_api != null) _missing = _api.wanted.getMissing(
            pageSize: SonarrDatabaseValue.CONTENT_LOAD_LENGTH.data,
            sortDir: SonarrSortDirection.DESCENDING,
            sortKey: SonarrWantedMissingSortKey.AIRDATE_UTC,
        );
        notifyListeners();
    }

    ///////////////
    /// HISTORY ///
    ///////////////
    
    Future<SonarrHistory> _history;
    Future<SonarrHistory> get history => _history;
    set history(Future<SonarrHistory> history) {
        assert(history != null);
        _history = history;
        notifyListeners();
    }

    void resetHistory() {
        if(_api != null) _history = _api.history.getHistory(
            page: 1,
            pageSize: SonarrDatabaseValue.CONTENT_LOAD_LENGTH.data,
            sortKey: SonarrHistorySortKey.DATE,
            sortDirection: SonarrSortDirection.DESCENDING,
        );
        notifyListeners();
    }


    ////////////////
    /// UPCOMING ///
    ////////////////
    
    Future<List<SonarrCalendar>> _upcoming;
    Future<List<SonarrCalendar>> get upcoming => _upcoming;
    set upcoming(Future<List<SonarrCalendar>> upcoming) {
        assert(upcoming != null);
        _upcoming = upcoming;
        notifyListeners();
    }

    void resetUpcoming() {
        DateTime start = DateTime.now();
        DateTime end = start.add(Duration(days: SonarrDatabaseValue.UPCOMING_FUTURE_DAYS.data));
        if(_api != null) _upcoming = _api.calendar.getCalendar(
            start: start,
            end: end,
        );
        notifyListeners();
    }


    ////////////////
    /// PROFILES ///
    ////////////////
    
    Future<List<SonarrQualityProfile>> _qualityProfiles;
    Future<List<SonarrQualityProfile>> get qualityProfiles => _qualityProfiles;
    set qualityProfiles(Future<List<SonarrQualityProfile>> qualityProfiles) {
        assert(qualityProfiles != null);
        _qualityProfiles = qualityProfiles;
        notifyListeners();
    }

    void resetQualityProfiles() {
        if(_api != null) _qualityProfiles = _api.profile.getQualityProfiles();
        notifyListeners();
    }

    Future<List<SonarrLanguageProfile>> _languageProfiles;
    Future<List<SonarrLanguageProfile>> get languageProfiles => _languageProfiles;
    set languageProfiles(Future<List<SonarrLanguageProfile>> languageProfiles) {
        assert(languageProfiles != null);
        _languageProfiles = languageProfiles;
        notifyListeners();
    }

    void resetLanguageProfiles() {
        if(_api != null && _enableVersion3) _languageProfiles = _api.profile.getLanguageProfiles();
        notifyListeners();
    }

    ////////////
    /// TAGS ///
    ////////////
    
    Future<List<SonarrTag>> _tags;
    Future<List<SonarrTag>> get tags => _tags;
    set tags(Future<List<SonarrTag>> tags) {
        assert(tags != null);
        _tags = tags;
        notifyListeners();
    }

    void resetTags() {
        if(_api != null) _tags = _api.tag.getTags();
        notifyListeners();
    }

    /////////////////////
    /// DELETE SERIES ///
    /////////////////////
    
    bool _removeSeriesDeleteFiles = false;
    bool get removeSeriesDeleteFiles => _removeSeriesDeleteFiles;
    set removeSeriesDeleteFiles(bool removeSeriesDeleteFiles) {
        assert(removeSeriesDeleteFiles != null);
        _removeSeriesDeleteFiles = removeSeriesDeleteFiles;
        notifyListeners();
    }

    //////////////
    /// IMAGES ///
    //////////////

    String getBannerURL(int seriesId, { bool highRes = false }) {
        if(_enabled) {
            String _base = _host.endsWith('/') ? '${_host}api/MediaCover' : '$_host/api/MediaCover';
            return highRes
                ? '$_base/$seriesId/banner.jpg?apikey=$_apiKey'
                : '$_base/$seriesId/banner-70.jpg?apikey=$_apiKey'; 
        }
        return null;
    }

    String getPosterURL(int seriesId, { bool highRes = false }) {
        if(_enabled) {
            String _base = _host.endsWith('/') ? '${_host}api/MediaCover' : '$_host/api/MediaCover';
            return highRes
                ? '$_base/$seriesId/poster.jpg?apikey=$_apiKey'
                : '$_base/$seriesId/poster-500.jpg?apikey=$_apiKey'; 
        }
        return null;
    }

    String getFanartURL(int seriesId, { bool highRes = false }) {
        if(_enabled) {
            String _base = _host.endsWith('/') ? '${_host}api/MediaCover' : '$_host/api/MediaCover';
            return highRes
                ? '$_base/$seriesId/fanart.jpg?apikey=$_apiKey'
                : '$_base/$seriesId/fanart-360.jpg?apikey=$_apiKey'; 
        }
        return null;
    }
}
