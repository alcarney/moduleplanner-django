from django.http import HttpResponse
from django.template import Template, Context
from django.template.loader import get_template
from django.views.generic import View
from tools.dbmanager import ModuleDB

# The module info view, used to display in depth information about a module
class ModuleInfoView(View):

    def get(self, request):

        # Create a new ModuleDB instance
        database = ModuleDB()

        # Get the record from the database
        module_info = database.getModule({"name": "Calculus"})

        # Load the template
        t = get_template("module.html")

        # Render the html
        html = t.render(Context({'name': module_info['name']}))

        return HttpResponse(html)

