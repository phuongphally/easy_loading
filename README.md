# easy_loading

Easy Loading

## Install
`easy_loading: ^0.0.1`

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
