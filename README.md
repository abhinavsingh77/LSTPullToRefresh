# LSTPullToRefresh
a sample app to show how to use LSTPullToRefresh and LSTTableViewPagination

There are two main classes in this project LSTTableViewPagination and LSTRefreshHeaderView

##LSTTableViewPagination 

This class provide basic functionality of Pagination in your table views.

To use this class.
Create another subclass of LSTTableViewPagination in your app to provide app specific functionality
eg. TableCell, RefreshView Class etc
See: MyTablePagination which is for to this project only.

*NOTE: LSTRefreshHeaderView class is required to use this class.*

##LSTRefreshHeaderView

This class provide basic functionality of Pull to load More and Pull to refresh.
eg, State of pull to refresh view, percentage dragged etc.

To use this class.
Create another subclass of LSTRefreshHeaderView in your app to provide app specific UI.
See: MyRefreshView which is for to this project only.

*NOTE: LSTTableViewPagination class is not required to use this class.*