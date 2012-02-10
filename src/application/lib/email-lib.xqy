(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



xquery version "1.0-ml";
(:~
 : Email Library Support for sending notifications.
 : @author <a href="gary.vidal@marklogic.com">Gary Vidal</a.>
~:)
module namespace email  ="http://www.xquerrail-framework.com/lib/email";

import module namespace jm = "http://www.xquerrail-framework.com/model/job"
    at "/application/model/job-model.xqy";
import module namespace pm = "http://www.xquerrail-framework.com/model/project"
    at "/application/model/project-model.xqy";
import module namespace vm = "http://www.xquerrail-framework.com/model/vendor"
    at "/application/model/vendor-model.xqy";
import module namespace um = "http://www.xquerrail-framework.com/model/user"
    at "/application/model/user-model.xqy";
            
declare namespace rf = "URN:ietf:params:rfc822:";
declare namespace em = "URN:ietf:params:email-xml:";

declare option xdmp:mapping "false";

(:~
 : Creates and email address according to schema 
 : @param $email - email of sender
~:)
declare function email:create-address(
    $email as xs:string
)  
{
  email:create-address($email,())
};

(:~
 : Creates an email address using name and email
 : @param $email - Email Address
 : @param $name - Name of Recipient 
~:)
declare function email:create-address(
    $email as xs:string,
    $name as xs:string?
)
{
    <em:Address>
      <em:adrs>{$email}</em:adrs>
      {if($name) then <em:name>{$name}</em:name> else ()}
    </em:Address>
};
(:~
 : Creates an email message
 : @param $from - Sender address
 : @param $to - Receipient Addresses
 : @param $subject - Subject of the email address
 : @param $body - Body of email 
~:)
declare function email:send-message(
    $from as element(em:Address),
    $to as element(em:Address)*,
    $subject as xs:string,
    $body as node()*
)
{
  let $recipients := for $t in $to  return <rf:to>{$t}</rf:to>
  let $smessage :=
      <em:Message xmlns:em="URN:ietf:params:email-xml:" xmlns:rf="URN:ietf:params:rfc822:">
      <rf:subject>{$subject}</rf:subject>
      <rf:from>
        {$from}
      </rf:from>
      {$recipients}
      <em:content>
         {$body}
      </em:content>
    </em:Message>
  let $email := try {xdmp:email($smessage)} catch($ex) {$ex}
  return
  (
       $email,
       $smessage
  )
};