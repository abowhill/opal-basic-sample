require 'opal'
require 'jquery'
require 'opal-jquery'
require 'date'

 
class WorkHistoryAnalysis
   attr_accessor :total, :company, :latest
 
   def initialize()
      @total_days = 0
      @company = Hash.new
      @last = Date.new(0,0,0)
   end
 
   def workedFor(who, from, to)
      to_d = Date.new(to[0],to[1],to[2])
      from_d = Date.new(from[0],from[1],from[2])
 
      latest?(to_d)
      days = (to_d - from_d).to_i
 
      if (@company.has_key?(who))
         @company[who] += days
      else
         @company[who] = days
      end
 
      @total_days += days
   end
 
   def latest?(dat)
      if (dat > @last) 
        @last = dat 
      else 
        return false
      end
      return true
   end
 
   def employed
      years = days2yrs(@total_days)
      ret =  "Employed for:\n"
      ret += "   #{years} years [#{@total_days} total days]\n"
      ret += "\n"
   end
 
   def unemployed
      days = Date.today - @last
      years = days2yrs(days)
      ret = "Currently unemployed for:\n"
      ret += "   #{years} years [#{days} days]\n"
      ret += "\n"
      ret += "Last worked:\n"
      ret += "   #{@last.to_s}\n"
      ret += "\n"
   end
 
   def days2yrs(days)
      pre_years = (days/365 * 100).to_i
      years = pre_years / 100
      return years.to_s
   end
 
   def list_experiences
      str = "Employment breakdown by company:\n"
      co = @company.sort_by { |k,v| v }
      co.each { |a| str += "   #{a[0]} #{days2yrs(a[1])} years [#{a[1]} days]\n" }
      return str
   end
 
   def print
      return employed + unemployed + list_experiences
   end
end
 
 
Document.ready? do
   b = Element['textarea']
   
   W = WorkHistoryAnalysis.new

   W.workedFor("NWlink",[1996,2,1],[1997,7,1])
   W.workedFor("Orrtax",[1997,8,1],[2000,1,1])
   W.workedFor("Hostpro",[2000,2,1],[2001,11,1])
   W.workedFor("College",[2002,4,1],[2005,12,16])
   W.workedFor("Microsoft",[2006,1,1],[2006,5,1])
   W.workedFor("Marchex",[2006,6,1],[2008,4,1])
   W.workedFor("Microsoft",[2008,10,1],[2009,9,26])
   W.workedFor("Microsoft",[2011,9,1],[2012,9,1])
   b.append("#{W.print}")
end
