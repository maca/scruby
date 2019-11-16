class Proc
  def arguments
    case arity
    when -1..0 then []
    when 1 then to_sexp.assoc( :dasgn_curr )[1].to_array
    else to_sexp[2][1][1..-1].collect{ |arg| arg[1]  }
    end
  end
  alias value call
end
