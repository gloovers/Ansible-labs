def sel(arg, name):
    import re

    result = ""
    for item in arg:
        if item['name'] == name:
             result = item['id']

    return result


class FilterModule(object):
    def filters(self):
        return {
            'sel': sel
        }

