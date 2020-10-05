# easy_loading



## Install 

```
dependencies:
  easy_loading: ^latest
```

## Usage

### ListView

```
EasyLoadingListView(
  loadMore: () async {
    await _loadNext();
  },
  hasMore: () => _hasNextPage,
  itemCount: () => items.length,
  itemBuilder: (context, index) {
    return _itemBuilder(items[index]);
  },
)

```

### GridView

```
EasyLoadingGridView(
  loadMore: () async {
    await _loadNext();
  },
  hasMore: () => _hasNextPage,
  itemCount: () => items.length,
  itemBuilder: (context, index) {
    return _itemBuilder(items[index]);
  },
)

```


### SliverGrid

```
EasyLoadingSliverGrid(
  loadMore: () async {
    await _loadNext();
  },
  hasMore: () => _hasNextPage,
  itemCount: () => items.length,
  itemBuilder: (context, index) {
    return _itemBuilder(items[index]);
  },
)

```
