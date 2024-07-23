<?php

namespace App\Http\Controllers;

use App\Models\Ticket;
use Illuminate\Http\Request;

class TicketController extends Controller
{
    public function ticketListing()
    {
        $tickets = Ticket::with('user') // Assuming 'user' is the relationship method in Ticket model
        ->orderBy('created_at', 'desc')
        ->paginate(10); // Adjust pagination as per your preference

        return view('admin.tickets.list',compact('tickets'));
    }
}
