#!/usr/bin/env python

# imports
import calendar
import datetime
import math
import sys
import subprocess

# static variables
lab_name = "synthetik_lab"
debug_job_numbers = False


def get_lab():
    return subprocess.check_output(['getent', 'group', 'synthetik_lab']);
    # return "synthetik_lab@usd.local:*:1093786979:peter.vonk@usd.local,jeffrey.heylmun@usd.local\n"


def gather_users():
    full_line = get_lab().rstrip()
    return full_line.split(":")[-1].split(",")


def get_node_hours_from_sacct(username, year, month):
    start_day_of_week, last_day = calendar.monthrange(year, month)
    start = str(year) + '-' + str(month).zfill(2) + '-01T00:00:00'
    end = str(year) + '-' + str(month).zfill(2) + '-' + str(last_day).zfill(2) + 'T23:59:59'
    sacct_output_format = "JobID,NNodes,Elapsed,Start,End"
    args = ['sacct', '-n', '-P', '-X', '-u', username, '-S', start, '-E', end, '-o', sacct_output_format]
    if debug_job_numbers:
        print " ".join(args)
    return sum_jobs_into_node_hours(subprocess.check_output(args), month, username)


def sum_jobs_into_node_hours(jobs, month, username):
    date_format = "%Y-%m-%dT%H:%M:%S"
    seconds_in_an_hour = 3600
    node_hours = 0
    for job in jobs.splitlines():
        jobid, num_nodes, elapsed, start, end = job.split('|')
        dt_start = datetime.datetime.strptime(start, date_format)
        dt_end = datetime.datetime.strptime(end, date_format)
        # Note: We only care about jobs that started this month, if a job
        # started last month, we are going to count that in the data from the
        # previous month. To accomplish this, skip any jobs that don't start
        # this month.
        if dt_start.month != month:
            continue
        # Note: for the hours, we convert seconds to hours,
        # then use a ceiling function to always 'round up'
        #hours = math.ceil((dt_end - dt_start).total_seconds() / seconds_in_an_hour)
        # Actually, lets round each job to 2 decimal places for a more accurate reading
        #hours = round((dt_end - dt_start).total_seconds() / seconds_in_an_hour, 4)
        hours = (dt_end - dt_start).total_seconds() / seconds_in_an_hour
        node_hours += int(num_nodes) * hours
        if debug_job_numbers:
            print "jobid:      "+jobid
            print "user:       "+username
            print "end:        "+end
            print "start:      "+start
            print "nodes:      "+num_nodes
            print "hours:      "+str(hours)
            print "nd_hrs:     "+str(int(num_nodes) * hours)
            print "nd_hrs_sum: "+str(node_hours)
    return node_hours


def select_month_to_gather_data():
    while True:
        question = "Enter a year: "
        raw_year = str(raw_input(question))
        try:
            year = int(raw_year)
        except:
            print('Enter numeric digits')
            continue
        if year < 0 or year > 9999:
            print('Enter a realistic year (ex. 2020)')
            continue
        break

    while True:
        question = "Enter a month: "
        raw_month = str(raw_input(question))
        try:
            month = int(raw_month)
        except:
            print('Enter numeric digits')
            continue
        if month < 1 or month > 12:
            print('Enter a realistic month (ex. 1-12)')
            continue
        break

    return year, month


def yes_or_no(question):
    while "user makes an invalid choice":
        reply = str(raw_input(question+' (Y/n) (default = y): ')).lower().strip()
        if len(reply) == 0:
            reply = 'y'
        if reply[0] == 'y':
            return True
        if reply[0] == 'n':
            return False


def get_year_month_from_argv1(arg):
    year, month = arg.split("/", 2)
    # Clean up data and convert to integers
    year = int(year.strip())
    month = int(month.strip())
    # Ensure ranges make sense
    if year < 0 or year > 9999:
        print "year: " + year
        raise Error
    if month < 1 or month > 12:
        print "month: " + month
        raise Error
    return (year, month);


def main():
    if len(sys.argv) > 2:
        print "Error, passed too many arguments, either pass a date in format YYYY/MM or pass nothing"
        exit(-1)

    if len(sys.argv) == 2:
        # Assume arg 1 is date in format YYYY/MM
        try:
            year, month = get_year_month_from_argv1(sys.argv[1])
        except:
            print "Error in your date, either pass no arguments, or pass 1 argument in the format YYYY/MM"
            exit(-1)
    else:
        prev_month = datetime.datetime.today().replace(day=1) - datetime.timedelta(days=1)
        year = prev_month.year
        month = prev_month.month

        if not yes_or_no("Gathering data for " + str(year) + "/" + str(month)):
            year, month = select_month_to_gather_data()

    hour_data = []
    total_hours = 0
    for user in gather_users():
        node_hours = get_node_hours_from_sacct(user, year, month)
        total_hours += node_hours
        hour_data.append([str(year) + "/" + str(month).zfill(2), user, str(node_hours)])

    # Print the header and then print the data
    print ",".join(["Year/Month","User","Node Hours"])
    for line in hour_data:
        print ",".join(line)

    # Print totals
    print "---------------------------------------"
    print "Total Node Hours for " + str(year) + "/" + str(month) + ":   " + str(round(total_hours, 2))


if __name__ == "__main__":
    main()
