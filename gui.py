from gui_programs import delete_user_tickets, get_user_total_ticket_amount, give_tickets, view_occupied_spots_count, view_tickets, view_user_vehicles, view_user_tickets, view_vehicles, view_vehicles_in_wrong_spots
from nicegui import ui,app


passwords = {
             'John Doe': 'john123',
             'Ben Doe': 'ben123',
             'May Doe': 'may123',
            'Peter Doe': 'peter123',
            'Frank Doe': 'frank123',
            'Owen Doe': 'owen123',
            'Nate Doe': 'nate123',
            'Josh Doe': 'josh123',
            'Emily Doe': 'emily123',
            'Tish Doe': 'tish123'
             }



@ui.page('/user')
def user_page():
    user =  app.storage.user.get('username')
    ui.label(f"Hello {user}")
    output = ui.table(columns=[], rows=[]).classes('hidden')
    
    pay_input = ui.number(label='Pay').classes('hidden w-75')
    pay_submit = ui.button('Pay').classes('hidden')

    def show_tickets():
        pay_input.classes('hidden')
        pay_input.update()

        pay_submit.classes('hidden')
        pay_submit.update()

        tickets = view_user_tickets(user)
        output.clear()
        output.columns =[
            {'name': 'plate', 'label': 'Plate', 'field': 'plate'},
            {'name': 'owed', 'label': 'Amount Owed', 'field': 'amount_owed'},
            {'name': 'due', 'label': 'Date Issued', 'field': 'date_issued'},
        ]
        rows = []
        for ticket in tickets:
            rows.append({
                'plate': ticket['plate_number'],
                'amount_owed': float(ticket['amount_owed']), 
                'date_issued': str(ticket['date_issued'])
            })
            
        output.rows = rows
        output.classes(remove='hidden')
        output.update()
    
    def show_vehicles():
        pay_input.classes('hidden')
        pay_input.update()

        pay_submit.classes('hidden')
        pay_submit.update()

        vehicles = view_user_vehicles(user)
        output.clear()
        output.columns =[
            {'name': 'plate', 'label': 'Plate', 'field': 'plate'},
            {'name': 'year', 'label': 'Vehicle Year', 'field': 'vehicle_year'},
            {'name': 'model', 'label': 'Model', 'field': 'model'},
        ]
        rows = []
        for vehicle in vehicles:
            rows.append({
                'plate': vehicle['plate_number'],
                'vehicle_year': float(vehicle['vehicle_year']), 
                'model': str(vehicle['model'])
            })
            
        output.rows = rows
        output.classes(remove='hidden')
        output.update()
    

    def pay_ticket():
        output.classes('hidden')
        output.update()
        amounted_owed = get_user_total_ticket_amount(user)

        if len(amounted_owed) == 0:
            amounted_owed = 0
        else:
            amounted_owed = float(get_user_total_ticket_amount(user)[0]['total_cost'])

        print(amounted_owed)

        if(amounted_owed == 0):
            pay_input.classes('hidden')
            pay_input.update()

            pay_submit.classes('hidden')
            pay_submit.update()
            ui.notify('No tickets')
            return 

        pay_input.classes(remove='hidden')
        pay_input.label = f'Please Pay: {str(amounted_owed)}'
        pay_input.update()

        pay_submit.classes(remove='hidden')

        def check_payment ():
            if(pay_input.value is None or pay_input.value != amounted_owed):
                ui.notify('Please pay full amount')
            else:
                delete_user_tickets(user)
        pay_submit.on_click(check_payment)
        pay_submit.update()


    with ui.header().classes('items-center bg-yellow-100'):
        ui.button('View Tickets', on_click=show_tickets)
        ui.button('View Vehicles', on_click=show_vehicles)
        ui.button('Pay Tickets', on_click=pay_ticket)
        ui.space()
        ui.button('Logout', icon='logout').props('flat') \
            .on_click(lambda: app.storage.user.clear()) \
            .on_click(lambda: ui.navigate.to('/'))

@ui.page('/admin')
def admin_page():
    ui.label("ADMIN PAGE")

    output = ui.table(columns=[], rows=[]).classes('hidden')
    
    def give_user_tickets():
        give_tickets()
        output.clear()
        output.classes('hidden')
        output.update()
        ui.notify('Tickets Given')

    def show_tickets():
        tickets = view_tickets()
        output.clear()
        output.columns =[
            {'name': 'plate', 'label': 'Plate', 'field': 'plate'},
            {'name': 'owed', 'label': 'Amount Owed', 'field': 'amount_owed'},
            {'name': 'due', 'label': 'Date Issued', 'field': 'date_issued'},
        ]

        rows = []
        for ticket in tickets:
            rows.append({
                'plate': ticket['plate_number'],
                'amount_owed': float(ticket['amount_owed']), 
                'date_issued': str(ticket['date_issued'])
            })
        output.rows = rows
        output.classes(remove='hidden')
        output.update()

    def show_vehicles():
        vehicles = view_vehicles()
        output.clear()
        output.columns =[
            {'name': 'plate', 'label': 'Plate', 'field': 'plate'},
            {'name': 'model', 'label': 'Model', 'field': 'model'},
            {'name': 'year', 'label': 'Year', 'field': 'year'},
        ]

        rows = []
        for vehicle in vehicles:
            rows.append({
                'plate': vehicle['plate_number'],
                'model': vehicle['model'], 
                'year': str(vehicle['vehicle_year'])
            })
        output.rows = rows
        output.classes(remove='hidden')
        output.update()
    
    def show_vehicles_in_wrong_spots():
        vehicles = view_vehicles_in_wrong_spots()
        output.clear()
        output.columns =[
            {'name': 'plate', 'label': 'Plate', 'field': 'plate'},
            {'name': 'name', 'label': 'Parking Lot Name', 'field': 'name'},
        ]

        rows = []
        for vehicle in vehicles:
            rows.append({
                'plate': vehicle['plate_number'],
                'name': vehicle['name'], 
            })
        output.rows = rows
        output.classes(remove='hidden')
        output.update()

    def show_occupied_spots_count():
        parking_lots = view_occupied_spots_count()
        output.clear()
        output.columns =[
            {'name': 'name', 'label': 'Parking Lot Name', 'field': 'name'},
            {'name': 'count', 'label': ' # of Occupied Spots', 'field': 'count'},
        ]

        rows = []
        for parking_lot in parking_lots:
            rows.append({
                'name': parking_lot['name'], 
                'count': parking_lot['occupied_spot_count'],
            })
        output.rows = rows
        output.classes(remove='hidden')
        output.update()

    with ui.header().classes('items-center bg-purple-100'):
        ui.button('Give Tickets', on_click=give_user_tickets)
        ui.button('View All Tickets', on_click=show_tickets)
        ui.button('View All Vehicles', on_click=show_vehicles)
        ui.button('View All Vehicles in Wrong Spots', on_click=show_vehicles_in_wrong_spots)
        ui.button('View Occupied Spot Count in Parking Lots', on_click=show_occupied_spots_count)

        # ui.button('Pay Tickets', on_click=pay_ticket)
        ui.space()
        ui.button('Logout', icon='logout').props('flat') \
            .on_click(lambda: app.storage.user.clear()) \
            .on_click(lambda: ui.navigate.to('/'))


@ui.page('/')
def login_page() -> None:

    def try_login():

        if passwords.get(username.value) == password.value:
            app.storage.user.update({'username': username.value})
            
            if(username.value == "Tish Doe" or username.value == "Nate Doe"):
                ui.navigate.to('/admin')
            else:
                ui.navigate.to('/user')
        else:
            ui.notify('Wrong username or password', color='negative')

    with ui.card().classes('absolute-center'):
        username = ui.input('Username').on('keydown.enter', try_login)
        password = ui.input('Password', password=True, password_toggle_button=True).on('keydown.enter', try_login)
        ui.button('Log in', on_click=try_login)




ui.run(storage_secret='123', port=8002)