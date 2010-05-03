# plasTeX renderer for Techrep version 1
# Copyright (c) 2010 CESNET
# Author: Ladislav Lhotka <Lhotka@cesnet.cz>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import string
from plasTeX.Renderers import Renderer

def omit(node):
    return u''

def enter(node):
    return unicode(node)

def handle_appendix(node):
    TechRep.inAppendix = True
    return u''

def handle_arraycell(node):
    return u'\n<td>%s</td>' % unicode(node)

def handle_arrayrow(node):
    return u'\n<tr>%s</tr>\n' % unicode(node)

def handle_bibitem(node):
    return u'\n<kniha id="%s">%s</kniha>\n' % (node.attributes['key'],
                                               unicode(node))
def handle_cite(node):
    return u'<cite href="%s"/>' % node.attributes['bibkeys'][0]

def handle_description(node):
    TechRep.dlist = True
    return u'\n<dl>%s</dl>\n' % unicode(node)

def handle_enumerate(node):
    TechRep.dlist = False
    return u'\n<ol>%s</ol>\n' % unicode(node)

def handle_document(node):
    ud = node.parentNode.userdata
    title = ud.get('title','')
    date = ud.get('date','')
    authors = ''
    if 'author' in ud:
        for cn in ud['author'].childNodes:
            if cn.nodeName == 'and':
                authors += ', '
            else:
                authors += unicode(cn).rstrip()
    return u'''<?xml version="1.0" encoding="utf-8"?>

<zprava cislo="XXXX">
<nazev>%s</nazev>
<autor>%s</autor>
<datum>%s</datum>

%s
</zprava>''' % (title,authors,date,unicode(node))

def figure_data(node, figdata):
    if node.nodeName in ('par','center','centering'):
        for cn in node.childNodes:
            figure_data(cn, figdata)
    elif node.nodeName == 'includegraphics':
        figdata['src'] = node.attributes['file']
    elif node.nodeName == 'label':
        figdata['label'] = node.attributes['label']
    elif node.nodeName == 'caption':
        figdata['caption'] = unicode(node)

def handle_figure(node):
    figdata = { 'label': '', 'src': '', 'caption': '' }
    for cn in node.childNodes:
        figure_data(cn, figdata)
    return u'\n<obr id="%s" src="%s">%s</obr>\n' % (figdata['label'],
                                                    figdata['src'],
                                                    figdata['caption'])
def handle_footnote(node):
    return u'<footnote>%s</footnote>' % unicode(node)

def handle_item(node):
    if TechRep.dlist:
        return u'\n<dt>%s</dt>\n<dd>%s</dd>' % (node.attributes['term'],
                                                unicode(node))
    else:
        return u'\n<li>%s</li>' % unicode(node)

def handle_itemize(node):
    TechRep.dlist = False
    return u'\n<ul>%s</ul>\n' % unicode(node)

def handle_nobreak(node):
    return u'~'

def handle_math(node):
    return u'<i>%s</i>' % unicode(node).strip().rstrip()

def handle_par(node):
    if node.parentNode.nodeName in ('bibitem', 'td'):
        return unicode(node)
    if node.hasChildNodes():
        try:
            while node.lastChild.isspace():
                node.pop()
        except AttributeError:
            pass
        lcn = node.lastChild.nodeName
        if lcn in ('label','input','bibliographystyle',
                   'maketitle'):
            return u''
                
        elif lcn in ('itemize','enumerate','figure','thebibliography',
                     'verbatim','pagebreak','appendix','description',
                     'table'):
            return unicode(node)
        elif lcn == 'abstract':
            return u'\n<h1>Abstract</h1>\n%s\n' % unicode(node.lastChild)
        else:
            return u'\n<p>%s</p>\n' % unicode(node).strip().rstrip()
    else:
        return u''

def handle_paragraph(node):
    return u'\n\n<p><b>%s</b></p>\n%s' % (unicode(node.title), unicode(node))

def handle_ref(node):
    return u'<a href="#%s"><XXX/></a>' % node.attributes['label']

def handle_section(node):
    res = u'\n<h1 id="%s">' % node.id
    if TechRep.inAppendix: res += 'Appendix. '
    return '%s%s</h1>\n%s' % (res,unicode(node.title),unicode(node))

def handle_subscript(node):
    return u'<sub>%s</sub>' % unicode(node)

def handle_superscript(node):
    return u'<sup>%s</sup>' % unicode(node)

def handle_subsection(node):
    return u'\n<h2 id="%s">%s</h2>\n%s' % (node.id, unicode(node.title),
                                           unicode(node))
def handle_subsubsection(node):
    return u'\n<h3 id="%s">%s</h3>\n%s' % (node.id, unicode(node.title),
                                           unicode(node))
def table_data(node, tabdata):
    if node.nodeName in ('par','center'):
        for cn in node.childNodes:
            table_data(cn, tabdata)
    elif node.nodeName == 'tabular':
        tabdata['colspec'] = node.attributes['colspec']
        tabdata['tabcont'] = unicode(node)
    elif node.nodeName == 'caption':
        tabdata['caption'] = unicode(node)
    elif node.nodeName == 'label':
        tabdata['label'] = node.attributes['label']

def handle_table(node):
    tabdata = { 'label': '', 'colspec': '',
                'tabcont': '', 'caption': '' }
    for cn in node.childNodes:
        table_data(cn, tabdata)
    return '''
<tab id="%s" sloupce="%s">
%s
<nazev>%s</nazev>
</tab>''' % (tabdata['label'],tabdata['colspec'],
             tabdata['tabcont'],tabdata['caption'])

def handle_textbf(node):
    return u'<b>%s</b>' % unicode(node).strip().rstrip()

def handle_textit(node):
    return u'<i>%s</i>' % unicode(node).strip().rstrip()

def handle_texttt(node):
    return u'<tt>%s</tt>' % unicode(node).strip().rstrip()

def handle_thebibliography(node):
    return u'\n\n<seznamknih>\n' + unicode(node) + u'\n</seznamknih>\n\n'

def handle_verbatim(node):
    return u'\n<blockquote><pre>%s</pre></blockquote>\n' % unicode(node) 

class TechRep(Renderer):

    inAppendix = False
    
    def __init__(self):
        Renderer.__init__(self)
        self.__setitem__('active::~', handle_nobreak)
        self.__setitem__('active::_', handle_subscript)
        self.__setitem__('active::^', handle_superscript)
        self.__setitem__('appendix', handle_appendix)
        self.__setitem__('ArrayCell', handle_arraycell)
        self.__setitem__('ArrayRow', handle_arrayrow)
        self.__setitem__('appendix', handle_appendix)
        self.__setitem__('bibitem', handle_bibitem)
        self.__setitem__('bigskip', omit)
        self.__setitem__('bf', handle_textbf)
        self.__setitem__('bfseries', handle_textbf)
        self.__setitem__('bibliographystyle', omit)
        self.__setitem__('bgroup', enter)
        self.__setitem__('cite', handle_cite)
        self.__setitem__('center', enter)
        self.__setitem__('centering', enter)
        self.__setitem__('description', handle_description)
        self.__setitem__('document', handle_document)
        self.__setitem__('em', handle_textit)
        self.__setitem__('emph', handle_textit)
        self.__setitem__('enumerate', handle_enumerate)
        self.__setitem__('figure', handle_figure)
        self.__setitem__('footnote', handle_footnote)
        self.__setitem__('input', omit)
        self.__setitem__('it', handle_textit)
        self.__setitem__('item', handle_item)
        self.__setitem__('itemize', handle_itemize)
        self.__setitem__('label', omit)
        self.__setitem__('large', enter)
        self.__setitem__('maketitle', omit)
        self.__setitem__('math', handle_math)
        self.__setitem__('medskip', omit)
        self.__setitem__('noindent', omit)
        self.__setitem__('pagebreak', omit)
        self.__setitem__('par', handle_par)
        self.__setitem__('paragraph', handle_paragraph)
        self.__setitem__('ref', handle_ref)
        self.__setitem__('relax', omit)
        self.__setitem__('section', handle_section)
        self.__setitem__('smallskip', omit)
        self.__setitem__('subsection', handle_subsection)
        self.__setitem__('subsubsection', handle_subsubsection)
        self.__setitem__('table', handle_table)
        self.__setitem__('textbf', handle_textbf)
        self.__setitem__('textit', handle_textit)
        self.__setitem__('texttt', handle_texttt)
        self.__setitem__('tt', handle_texttt)
        self.__setitem__('thebibliography', handle_thebibliography)
        self.__setitem__('verb', handle_texttt)
        self.__setitem__('verbatim', handle_verbatim)
        self.__setitem__('vspace', omit)

    def default(self, node):
        """ Rendering method for all non-text nodes """
        s = []

        # Handle characters like \&, \$, \%, etc.
        if len(node.nodeName) == 1 and node.nodeName not in string.letters:
            return self.textDefault(node.nodeName)

        # Start tag
        s.append('<%s>' % node.nodeName)

        # See if we have any attributes to render
        if node.hasAttributes():
            s.append('<attributes>')
            for key, value in node.attributes.items():
                # If the key is 'self', don't render it
                # these nodes are the same as the child nodes
                if key == 'self':
                    continue
                s.append('<%s>%s</%s>' % (key, unicode(value), key))
            s.append('</attributes>')

        # Invoke rendering on child nodes
        s.append(unicode(node))

        # End tag
        s.append('</%s>' % node.nodeName)

        return u'\n'.join(s)

    def textDefault(self, node):
        """ Rendering method for all text nodes """
        return node.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
