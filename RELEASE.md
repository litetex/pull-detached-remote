
# Manual for Releasing

## Create a new *development* release (vdev)

### Delete a existing release
To delete an existing release simply delete the ``vdev`` tag
* Checkout the repository (branch: ``develop``)
* Update the tags
```
git fetch --tags
```
* Delete the tag and push the deletion
```
git tag -d vdev
git push origin :refs/tags/vdev
```


### Create a new release 
Create a new release with the ``vdev`` tag
* Click "create a new release"
* Set the following:
  * ``tag``=``vdev``
  * ``targeted branch/commit``=``develop``
